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
        [Authorize(Roles = RoleEnum.PHUHUYNH)]
        [HttpPost("dangky-duadon")]
        public async Task<IActionResult> DangKyXeDuaDonAsync([FromBody] DangKyXeDuadonViewModel dto)
        {
            if (dto == null)
                return BadRequest("Dữ liệu không hợp lệ.");
            var tableName = "public." + Sql.Entity<DangkyXeDuadon>();
            using var session = OpenSession();
            var hocSinh = (await session.Connection.FindAsync<Hocsinh>(stm => stm
                .Where($"{nameof(Hocsinh.ma_hocsinh)} = @studentCode")
                .WithParameters(new { studentCode = dto.ma_hocsinh })
            )).FirstOrDefault();

            if (hocSinh == null)
                return NotFound("Mã học sinh không tồn tại.");

            await session.Connection.ExecuteAsync($@"
                INSERT INTO {tableName} (
                    {nameof(DangkyXeDuadon.hocsinh_id)},
                    {nameof(DangkyXeDuadon.dia_chi)},
                    {nameof(DangkyXeDuadon.lat)},
                    {nameof(DangkyXeDuadon.lon)},
                    {nameof(DangkyXeDuadon.loai_dichvu_id)},
                    {nameof(DangkyXeDuadon.ghi_chu)})
                VALUES (
                    @hocsinh_id,
                    @dia_chi,
                    @lat,
                    @lon,
                    @loai_dichvu_id,
                    @ghi_chu)
            ", new { hocsinh_id = hocSinh.id, dto.dia_chi, dto.lat, dto.lon, dto.loai_dichvu_id, dto.ghi_chu });

            return Ok(new { message = "Đăng ký xe đưa đón thành công." });
        }

        [HttpDelete("huy-dangky-tuyenxe")]
        [Authorize(Roles = RoleEnum.PHUHUYNH)]
        public async Task<IActionResult> HuyDangKyXeDuadonAsync([FromBody] DangkyXeDuadon dto)
        {
            using var session = OpenSession();
            var tableName = "public." + Sql.Entity<DangkyXeDuadon>();

            await session.Connection.ExecuteAsync($@"
                DELETE FROM {tableName}
                WHERE {nameof(DangkyXeDuadon.id)} = @id
            ", new { dto.id });

            return Ok(new { message = "Hủy đăng ký tuyến xe thành công." });
        }

        [HttpGet("thongtin-da-dangky/{id}")]
        [Authorize(Roles = RoleEnum.PHUHUYNH)]
        public async Task<IActionResult> GetThongtinDaDangky([FromRoute] int id )
        {
            using var session = OpenSession();

            var item = await session.Connection.GetAsync<DangkyXeDuadon>(new DangkyXeDuadon
                { id = id }
            );
            return Ok(item);
        }
    }
}