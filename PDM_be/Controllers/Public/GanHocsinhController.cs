using System.Security.Claims;
using Dapper;
using Dapper.FastCrud;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PDM_be.Enums;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models.Category;
using PDM_be.Models.Public;

namespace PDM_be.Controllers.Public
{
    [ApiController]
    [Authorize(Roles = RoleEnum.PHUHUYNH)]
    [Route("api/phu-huynh")]
    public class GanHocsinhController : ControllerBase
    {
        private readonly IDbFactory _dbFactory;
        public GanHocsinhController(IDbFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }
        protected IDbSession OpenSession()
        {
            return _dbFactory.Create<DbSession>();
        }

        [HttpPost("gan-hocsinh")]
        public async Task<IActionResult> GanHocsinhAsync([FromForm] string studentCode)
        {
            var tableName = "public." + Sql.Entity<PhuhuynhHocsinh>();

            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            using var session = OpenSession();

            var hocSinhs = await session.Connection.FindAsync<Hocsinh>(stm => stm
                .Where($"{nameof(Hocsinh.ma_hocsinh)} = @studentCode")
                .WithParameters(new { studentCode })
            );
            var hocSinhExitst = hocSinhs.FirstOrDefault();

            if (hocSinhExitst == null)
                return NotFound("Mã học sinh không tồn tại.");

            var exists = await session.Connection.CountAsync<PhuhuynhHocsinh>(stm => stm
                .Where($@"{nameof(PhuhuynhHocsinh.phuhuynh_id)} = @phuHuynhId AND 
                          {nameof(PhuhuynhHocsinh.hocsinh_id)} = @hocSinhId")
                .WithParameters(new { phuHuynhId = userId, hocSinhId = hocSinhExitst.id })
            );
            if (exists > 0)
                return BadRequest("Học sinh đã được gán trước đó.");

            await session.Connection.ExecuteAsync(
                $@"INSERT INTO {tableName}({nameof(PhuhuynhHocsinh.phuhuynh_id)}, {nameof(PhuhuynhHocsinh.hocsinh_id)})
                   VALUES (@phuHuynhId, @hocSinhId)",
                new { phuHuynhId = userId, hocSinhId = hocSinhExitst.id }
            );

            return Ok(new { message = "Gán học sinh thành công.", hocSinhExitst });
        }
    }
}