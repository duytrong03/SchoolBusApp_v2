using Dapper;
using Dapper.FastCrud;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PDM_be.Enums;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Identity.ViewModels;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models;
using PDM_be.Models.Category;
using PDM_be.Models.Public;
using PDM_be.ViewModels;

namespace PDM_be.Controllers.Admin
{
    [ApiController]
    [Authorize(Roles = RoleEnum.ADMIN)]
    [Route("api/admin")]
    public class AdminController : ControllerBase
    {
        private readonly IDbFactory _dbFactory;
        private readonly IUnitOfWork _uow;

        public AdminController(IDbFactory dbFactory, IUnitOfWork uow)
        {
            _dbFactory = dbFactory;
            _uow = uow;
        }
        protected IDbSession OpenSession()
        {
            return _dbFactory.Create<DbSession>();
        }
        [HttpPost("create-driver")]
        public async Task<IActionResult> CreateDriverAsync([FromBody] CreateDriverModel input)
        {
            var tableTaikhoan = "public." + Sql.Entity<TaiKhoan>();
            var tableTaixe = "public." + Sql.Entity<Taixe>();

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            using var session = OpenSession();
            try
            {
                var exists = await session.Connection.CountAsync<TaiKhoan>(stm => stm
                    .Where($"{nameof(TaiKhoan.username):C} = @username")
                    .WithParameters(new { username = input.username })
                );
                if (exists > 0)
                    return BadRequest("Tên đăng nhập đã tồn tại.");
                string hash = BCrypt.Net.BCrypt.HashPassword(input.password);

                var sqlTaikhoan = $@"
                    INSERT INTO {tableTaikhoan}({nameof(TaiKhoan.username)}, {nameof(TaiKhoan.password_hash)}, {nameof(TaiKhoan.role)},
                                                {nameof(TaiKhoan.ho_ten)}, {nameof(TaiKhoan.so_dienthoai)}, {nameof(TaiKhoan.email)})
                    VALUES (@username, @password_hash, @role, @ho_ten, @so_dienthoai, @email)
                    RETURNING id";

                var taiKhoanId = await session.Connection.ExecuteScalarAsync<int>(sqlTaikhoan, new
                {
                    username = input.username,
                    password_hash = hash,
                    role = RoleEnum.TAIXE,
                    ho_ten = input.ho_ten,
                    so_dienthoai = input.so_dienthoai,
                    email = input.email
                });

                var sqlTaixe = $@" 
                    INSERT INTO {tableTaixe}({nameof(Taixe.ho_ten)}, {nameof(Taixe.so_dienthoai)}, {nameof(Taixe.bang_lai)})
                    VALUES (@ho_ten, @so_dienthoai, @bang_lai)
                    RETURNING id";

                var taiXeId = await session.Connection.ExecuteScalarAsync<int>(sqlTaixe, new
                {
                    ho_ten = input.ho_ten,
                    so_dienthoai = input.so_dienthoai,
                    bang_lai = input.bang_lai
                });
                _uow.Commit();
                return Ok(new
                {
                    userId = taiKhoanId,
                    driverId = taiXeId,
                    message = "Tạo tài xế thành công."
                });
            }
            catch
            {
                _uow.Rollback();
                throw;
            }
        }

        [HttpPost("assign-student-to-parent")]
        public async Task<IActionResult> AssignStudentToParentAsync([FromForm] AssignStudentRequest request)
        {

            var tableName = "public." + Sql.Entity<PhuhuynhHocsinh>();
            using var session = OpenSession();

            var hocSinhs = await session.Connection.FindAsync<Hocsinh>(stm => stm
                .Where($"{nameof(Hocsinh.ma_hocsinh)} = @studentCode")
                .WithParameters(new { studentCode = request.ma_hocsinh })
            );
            var hocSinhExitst = hocSinhs.FirstOrDefault();

            if (hocSinhExitst == null)
                return NotFound("Mã học sinh không tồn tại.");

            if (string.IsNullOrEmpty(request.username) || string.IsNullOrEmpty(request.ho_ten))
                return BadRequest("Tên đăng nhập hoặc họ tên phụ huynh không được để trống.");

            var phuHuynhExist = await session.Connection.GetAsync<TaiKhoan>(new TaiKhoan { username = request.username, ho_ten = request.ho_ten });

            if (phuHuynhExist == null)
                return NotFound("Tài khoản phụ huynh không tồn tại.");

            await session.Connection.ExecuteAsync(
                $@"INSERT INTO {tableName}({nameof(PhuhuynhHocsinh.phuhuynh_id)}, {nameof(PhuhuynhHocsinh.hocsinh_id)})
                   VALUES (@phuHuynhId, @hocSinhId)",
                new { phuHuynhId = phuHuynhExist.id, hocSinhId = hocSinhExitst.id }
            );
            
            return Ok(new { message = "Gán học sinh thành công.", hocSinhExitst });
        }
    }
}