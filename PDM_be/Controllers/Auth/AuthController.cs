using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Dapper;
using Dapper.FastCrud;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using PDM_be.Enums;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Identity.ViewModels;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models;

namespace PDM_be.Controllers.Auth
{
    [ApiController]
    [Route("api/auth")]
    public class AuthController : ControllerBase
    {
        private readonly IDbFactory _dbFactory;
        private readonly string _jwtKey;
        private readonly string _jwtIssuer;
        private readonly string _jwtAudience;
        public AuthController(IDbFactory dbFactory, IConfiguration configuration)
        {
            _dbFactory = dbFactory;
            _jwtKey = configuration["Jwt:key"]
                ?? throw new InvalidOperationException("Missing Jwt:Key in configuration");
            _jwtIssuer = configuration["jwt:Issuer"]
                ?? throw new InvalidOperationException("Missing Jwt:Issuer in configuration");
            _jwtAudience = configuration["jwt:Audience"]
                ?? throw new InvalidOperationException("Missing Jwt:Audience in configuration");
        }

        protected IDbSession OpenSession()
        {
            return _dbFactory.Create<DbSession>();
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginInputModel input)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            using var session = OpenSession();

            var user = (await session.Connection.FindAsync<TaiKhoan>(x => x
                .Where($"{Sql.Entity<TaiKhoan>(x => x.username):TC} = @Username")
                .WithParameters(new { Username = input.username })
            )).FirstOrDefault();

            if (user == null) return Unauthorized(new { message = "Tài khoản hoặc mật khẩu không đúng." });

            if (!BCrypt.Net.BCrypt.Verify(input.password!, user.password_hash))
                return Unauthorized(new { message = "Tài khoản hoặc mật khẩu không đúng." });

            var token = GenerateJwtToken(user, input.rememberLogin);

            return Ok(new
            {
                token = token,
                role = user.role,
            });
        }

        private object GenerateJwtToken(TaiKhoan user, bool rememberLogin)
        {
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.id.ToString()),
                new Claim(ClaimTypes.Name, user.username),
                new Claim(ClaimTypes.Role, user.role)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var expires = rememberLogin ? DateTime.Now.AddDays(7) : DateTime.Now.AddHours(8);

            var token = new JwtSecurityToken(
                issuer: _jwtIssuer,
                audience: _jwtAudience,
                claims: claims,
                expires: expires,
                signingCredentials: creds);
            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        [HttpPost("register-parent")]
        public async Task<IActionResult> RegisterParent([FromBody] RegisterParentModel input)
        {
            var tableName = "public." + Sql.Entity<TaiKhoan>();
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            using var session = OpenSession();

            var exist = (await session.Connection.CountAsync<TaiKhoan>(stm => stm
                .Where($"{Sql.Entity<TaiKhoan>(x => x.username):TC} = @Username")
                .WithParameters(new { Username = input.username }))
            );

            if (exist > 0)
                return BadRequest(new { message = "Tên đăng nhập đã tồn tại." });

            string hash = BCrypt.Net.BCrypt.HashPassword(input.password);

            var sql = $@"
                INSERT INTO {tableName}({nameof(TaiKhoan.username)}, {nameof(TaiKhoan.password_hash)}, {nameof(TaiKhoan.role)}, 
                            {nameof(TaiKhoan.ho_ten)}, {nameof(TaiKhoan.so_dienthoai)}, {nameof(TaiKhoan.email)})
                VALUES (@username, @password_hash, @role, @ho_ten, @so_dienthoai, @email)
                RETURNING id
            ";
            var id = await session.Connection.ExecuteScalarAsync<int>(sql, new
            {
                username = input.username,
                password_hash = hash,
                role = RoleEnum.PHUHUYNH,
                ho_ten = input.ho_ten,
                so_dienthoai = input.so_dienthoai,
                email = input.email
            });

            return Ok(new { id, message = "Đăng ký phụ huynh thành công" });
        }
    }
}