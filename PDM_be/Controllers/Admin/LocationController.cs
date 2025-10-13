using Dapper;
using Dapper.FastCrud;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PDM_be.Enums;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models.Public;
using PDM_be.ViewModels.Admin;

namespace PDM_be.Controllers.Admin
{
    [ApiController]
    [Authorize(Roles = RoleEnum.ADMIN)]
    public class LocationController : ControllerBase
    {
        private readonly IDbFactory _dbFactory;
        private readonly IUnitOfWork _uow;
        public LocationController(IDbFactory dbFactory, IUnitOfWork uow)
        {
            _dbFactory = dbFactory;
            _uow = uow;
        }
        protected IDbSession OpenSession()
        {
            return _dbFactory.Create<DbSession>();
        }
        [HttpPost("update-location")]
        public async Task<IActionResult> UpdateLocationAsync([FromBody] XeLocationViewModel dto)
        {
            if (dto == null || dto.xe_id <= 0)
                return BadRequest("Dữ liệu không hợp lệ.");
            var tableHienTai = "public." + Sql.Entity<XeHientai>();
            using var session = OpenSession();
            var exists = await session.Connection.CountAsync<XeHientai>(stm => stm
                .Where($"{nameof(XeHientai.xe_id)} = @xeId")
                .WithParameters(new { xeId = dto.xe_id })
            );

            if (exists > 0)
            {
                await session.Connection.ExecuteAsync($@"
                    UPDATE {tableHienTai}
                    SET {nameof(XeHientai.vi_do)} = @viDo,
                        {nameof(XeHientai.kinh_do)} = @kinhDo,
                        {nameof(XeHientai.toc_do)} = @tocDo,
                        {nameof(XeHientai.huong_di)} = @huongDi,
                        {nameof(XeHientai.cap_nhat)} = @capNhat,
                    WHERE {nameof(XeHientai.xe_id)} = @xeId",
                    new
                    {
                        xeId = dto.xe_id,
                        viDo = dto.vi_do,
                        kinhDo = dto.kinh_do,
                        tocDo = dto.toc_do,
                        huongDi = dto.huong_di,
                        capNhat = DateTime.Now
                    });
            }
            else
            {
                await session.Connection.ExecuteAsync($@"
                    INSERT INTO {tableHienTai}
                        ({nameof(XeHientai.xe_id)}, {nameof(XeHientai.vi_do)}, {nameof(XeHientai.kinh_do)}, 
                        {nameof(XeHientai.toc_do)}, {nameof(XeHientai.huong_di)}, {nameof(XeHientai.cap_nhat)})
                    VALUES (@xeId, @viDo, @kinhDo, @tocDo, @huongDi, @capNhat)
                ", new
                {
                    xeId = dto.xe_id,
                    viDo = dto.vi_do,
                    kinhDo = dto.kinh_do,
                    tocDo = dto.toc_do,
                    huongDi = dto.huong_di,
                    capNhat = DateTime.Now
                });
            }
            var tableLichSu = "public." + Sql.Entity<XeLichsu>();
            await session.Connection.ExecuteAsync($@"
            INSERT INTO {tableLichSu}
                ({nameof(XeLichsu.xe_id)}, {nameof(XeLichsu.vi_do)}, {nameof(XeLichsu.kinh_do)}, 
                {nameof(XeLichsu.toc_do)}, {nameof(XeLichsu.huong_di)}, {nameof(XeLichsu.thoi_gian)})
            VALUES (@xeId, @viDo, @kinhDo, @tocDo, @huongDi, @thoiGian)
            ", new
            {
                xeId = dto.xe_id,
                viDo = dto.vi_do,
                kinhDo = dto.kinh_do,
                tocDo = dto.toc_do,
                huongDi = dto.huong_di,
                thoiGian = DateTime.Now
            });
            
            return Ok(new { message = "Cập nhật vị trí xe thành công." });
        }
    }
}