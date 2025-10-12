using Dapper;
using Dapper.FastCrud;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PDM_be.Enums;
using PDM_be.Models.Public;
using PDM_be.ViewModels;

namespace PDM_be.Controllers.Public
{
    public partial class PublicApiController
    {
        [HttpPost("dangky-tuyenxe")]
        [Authorize(Roles = RoleEnum.PHUHUYNH)]
        public async Task<IActionResult> DangKyTuyenXeAsync([FromBody] DangKyTuyenViewModel dto)
        {
            if (dto == null || dto.hocsinh_id <= 0 || dto.tuyen_id <= 0)
                return BadRequest("Dữ liệu không hợp lệ.");
            using var session = OpenSession();
            var tableName = "public." + Sql.Entity<DangkyTuyen>();
            var hocSinh = await session.Connection.GetAsync<Hocsinh>(new Hocsinh { id = dto.hocsinh_id });
            if (hocSinh == null)
                return NotFound("Học sinh không tồn tại.");
            var tuyenXe = await session.Connection.GetAsync<TuyenXe>(new TuyenXe { id = dto.tuyen_id });
            if (tuyenXe == null)
                return NotFound("Tuyến xe không tồn tại.");

            var existed = await session.Connection.CountAsync<DangkyTuyen>(stm => stm
                .Where($@"{nameof(DangkyTuyen.hocsinh_id)} = @hocSinhId 
                        AND {nameof(DangkyTuyen.tuyen_id)} = @tuyenId")
                .WithParameters(new { hocSinhId = dto.hocsinh_id, tuyenId = dto.tuyen_id })
            );
            if (existed > 0)
                return BadRequest("Học sinh đã đăng ký tuyến xe này.");

            await session.Connection.ExecuteAsync($@"
                INSERT INTO {tableName}(
                    {nameof(DangkyTuyen.hocsinh_id)},
                    {nameof(DangkyTuyen.tuyen_id)}
                )
                VALUES (@hocSinhId, @tuyenId)
            ", new { hocSinhId = dto.hocsinh_id, tuyenId = dto.tuyen_id });

            return Ok(new { message = "Đăng ký tuyến xe thành công." });
        }

        [HttpDelete("huy-dangky-tuyenxe")]
        [Authorize(Roles = RoleEnum.PHUHUYNH)]
        public async Task<IActionResult> HuyDangKyTuyenXeAsync([FromBody] DangKyTuyenViewModel dto)
        {
            if (dto == null || dto.hocsinh_id <= 0 || dto.tuyen_id <= 0)
                return BadRequest("Dữ liệu không hợp lệ.");
            using var session = OpenSession();
            var tableName = "public." + Sql.Entity<DangkyTuyen>();

            var existed = await session.Connection.CountAsync<DangkyTuyen>(stm => stm
                .Where($@"{nameof(DangkyTuyen.hocsinh_id)} = @hocSinhId 
                        AND {nameof(DangkyTuyen.tuyen_id)} = @tuyenId")
                .WithParameters(new { hocSinhId = dto.hocsinh_id, tuyenId = dto.tuyen_id })
            );
            if (existed == 0)
                return NotFound("Học sinh chưa đăng ký tuyến này.");

            await session.Connection.ExecuteAsync($@"
                DELETE FROM {tableName}
                WHERE {nameof(DangkyTuyen.hocsinh_id)} = @hocSinhId
                AND {nameof(DangkyTuyen.tuyen_id)} = @tuyenId
            ", new { hocSinhId = dto.hocsinh_id, tuyenId = dto.tuyen_id });

            return Ok(new { message = "Hủy đăng ký tuyến xe thành công." });
        }

        [HttpGet("hoc-sinh/tuyen-xe")]
        [Authorize(Roles = RoleEnum.PHUHUYNH)]
        public async Task<IActionResult> GetTuyenXeDaDangky(int studentCode)
        {
            using var session = OpenSession();

            var item = await session.Connection.GetAsync<DangkyTuyen>(new DangkyTuyen
                { hocsinh_id = studentCode },
                stm => stm.Include<TuyenXe>(x => x.LeftOuterJoin())
            );
            if (item == null)
                return NotFound("Học sinh chưa đăng ký tuyến xe nào.");
            return Ok(item);
        }
    }
}