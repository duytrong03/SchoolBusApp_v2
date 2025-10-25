using Dapper;
using Dapper.FastCrud;
using Microsoft.AspNetCore.Mvc;
using PDM_be.Models.Public;
using PDM_be.ViewModels.Admin;

namespace PDM_be.Controllers.Admin
{
    public partial class AdminController
    {
        [HttpPut("phan-hoi")]
        public async Task<IActionResult> PhanhoiDangkyAsync([FromBody] PhanhoiDangkyViewModel dto)
        {
            using var session = OpenSession();
            var tableName = "public." + Sql.Entity<DangkyXeDuadon>();

            var record = (await session.Connection.FindAsync<DangkyXeDuadon>(stm => stm
                .Where($"{nameof(DangkyXeDuadon.id)} = @id")
                .WithParameters(new { dto.id })
            )).FirstOrDefault();

            if (record == null)
                return NotFound("Không tìm thấy đăng ký.");

            await session.Connection.ExecuteAsync($@"
                UPDATE {tableName}
                SET 
                    trang_thai = @trang_thai,
                    quantri_ghichu = @quantri_ghichu,
                    ngay_duyet = NOW()
                WHERE id = @id", new
            {
                dto.id,
                trang_thai = dto.trang_thai.GetDisplayName(),
                dto.quantri_ghichu
            });

            return Ok(new { message = $"Phản hồi thành công: {dto.trang_thai}" });
        }
    }
}