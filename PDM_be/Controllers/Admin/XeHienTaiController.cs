using Dapper;
using Dapper.FastCrud;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PDM_be.Enums;
using PDM_be.Helpers;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Abstractions;
using PDM_be.Infrastructure.DTO.Response;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models.Public;
using PDM_be.Repositories.Interfaces;
using PDM_be.ViewModels.DTO;

namespace PDM_be.Controllers
{
    [ApiController]
    [Authorize(Roles = RoleEnum.ADMIN)]
    [Route("api/xe-hientai")]
    public class XeHientaiController : BaseApiCRUDController<DbSession, XeHientai, int>
    {
        public XeHientaiController(IDbFactory dbFactory, IRepository<XeHientai, int> repository)
        : base(dbFactory, repository)
        {
        }
        [HttpPost("datatable")]
        public async Task<IActionResult> DatatableAsync([FromBody] TableParameters dataTb)
        {
            using var session = OpenSession();
            string condition = $"(1=1)";
            string tableAlias = typeof(XeHientai).Name.ToLower();
            string order = $" 1 ASC";
            List<XeHientai> data;

            var recordsTotal = await session.Connection.CountAsync<XeHientai>(stm => stm
                .WithAlias(tableAlias).Where($"{condition}")
                .WithParameters(dataTb));

            if (dataTb != null && dataTb.search != null && string.IsNullOrEmpty(dataTb.search?.value) == false)
            {
                condition += $" AND ({tableAlias}.\"search_content\" @@ to_tsquery(@keyword))";
            }

            if (dataTb != null && dataTb.orders != null && dataTb.orders.Count() > 0)
            {
                var tableName = RepoDBHepler.OnlyTableName<XeHientai>();
                var existFields = session.Connection.QueryFirstOrDefault<int>(
                    $"select COUNT(1) from information_schema.columns WHERE table_name = @tableName AND column_name = ANY(@sortFields)",
                    new
                    {
                        tableName,
                        sortFields = dataTb?.orders.Select(x => x.prop).ToArray()
                    });
                if (existFields != dataTb?.orders?.Count())
                {
                    return BadRequest("Lỗi tham số orders! Vui lòng kiểm tra lại.");
                }
                order = string.Join(", ", dataTb.orders.Select(x => $"{tableAlias}.{x.prop} {(x.order.Equals("descending") == true ? "desc" : "asc")}"));
            }

            var withParams = new
            {
                keyword = dataTb?.search?.value
            };

            if (dataTb?.length == -1)
            {
                data = (await session.Connection.FindAsync<XeHientai>(stm => stm
                    .Include<XeHientai>(x => x.LeftOuterJoin())
                    .WithAlias(tableAlias)
                    .Where($"{condition}")
                    .WithParameters(withParams)
                    .OrderBy($"{order}"))
                ).ToList();
            }
            else if (dataTb?.length == 0)
            {
                data = new List<XeHientai>();
            }
            else
            {
                data = (await session.Connection.FindAsync<XeHientai>(stm => stm
                    .Include<XeHientai>(x => x.LeftOuterJoin())
                    .WithAlias(tableAlias)
                    .Where($"{condition}")
                    .WithParameters(withParams)
                    .OrderBy($"{order}")
                    .Skip(dataTb?.start ?? 0)
                    .Top(dataTb?.length ?? 10))
                ).ToList();
            }

            return Ok(new RestPagedDataTable<IEnumerable<XeHientai>>
            {
                data = data,
                recordsFiltered = await session.Connection.CountAsync<XeHientai>(stm => stm
                    .WithAlias(tableAlias)
                    .Where($"{condition}")
                    .WithParameters(withParams)
                ),
                recordsTotal = recordsTotal,
                draw = dataTb?.draw ?? 1
            });
        }
    }
}