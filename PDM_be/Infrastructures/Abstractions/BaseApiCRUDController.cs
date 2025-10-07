using System.Data;
using Dapper.FastCrud;
using Microsoft.AspNetCore.Mvc;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Repositories.Implementations;
using PDM_be.Repositories.Interfaces;

namespace PDM_be.Infrastructure.Abstractions
{
    [ApiController]
    public abstract class BaseApiCRUDController<TSession, TEntity, TPk> : ControllerBase
        where TSession : class, IDbSession where TEntity : class, new() where TPk : IComparable
    {
        protected readonly IDbFactory DbFactory;
        protected readonly IRepository<TEntity, TPk> Repository;

        public BaseApiCRUDController(IDbFactory dbFactory, IRepository<TEntity, TPk> repository)
        {
            DbFactory = dbFactory;
            Repository = repository;
        }

        protected IDbSession OpenSession()
        {
            return DbFactory.Create<DbSession>();
        }

        [HttpGet]
        public virtual async Task<IActionResult> GetAllAsync(
            [FromQuery] string? q,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 15
        )
        {
            using var session = OpenSession();

            IEnumerable<TEntity> data;
            if (pageSize == -1)
            {
                data = await session.Connection.FindAsync<TEntity>();
            }
            else
            {
                data = await session.Connection.FindAsync<TEntity>(stm => stm
                    .OrderBy($"id")
                    .Skip((page - 1) * pageSize)
                    .Top(pageSize));
            }
            return Ok(new { data = data });
        }

        [HttpGet("{id}")]
        public virtual async Task<IActionResult> GetKeyAsync([FromRoute] TPk id)
        {
            using var session = OpenSession();
            var item = await Repository.GetKeyAsync(id, session);
            return Ok(new { data = item });
        }

        [HttpPost]
        public virtual async Task<IActionResult> InsertAsync([FromBody] TEntity entity)
        {
            if (entity == null) return BadRequest("Dữ liệu không hợp lệ.");
            using var session = OpenSession();
            using var uow = new UnitOfWork(session.Connection, session.SqlDialect, IsolationLevel.RepeatableRead);
            var key = await Repository.SaveOrUpdateAsync(entity, uow);
            return Ok(new { data = key });
        }

        [HttpPut]
        public virtual async Task<IActionResult> UpdateAsync([FromBody] TEntity entity)
        {
            if (entity == null) return BadRequest("Dữ liệu không hợp lệ.");
            using var session = OpenSession();
            using var uow = new UnitOfWork(session.Connection, session.SqlDialect, IsolationLevel.RepeatableRead);
            if (await Repository.GetAsync(entity, session) == null)
                return NotFound("Không tìm thấy bản ghi.");
            await Repository.SaveOrUpdateAsync(entity, uow);
            return Ok(new {message ="Cập nhật dữ liệu thành công."});
        }

        [HttpDelete]
        public virtual async Task<IActionResult> DeleteAsync([FromBody] TEntity entity)
        {
            if (entity == null) return BadRequest("Dữ liệu không hợp lệ.");
            using var session = OpenSession();
            using var uow = new UnitOfWork(session.Connection, session.SqlDialect, IsolationLevel.RepeatableRead);
            
            if (await Repository.GetAsync(entity, session) == null)
                return NotFound("không tìm thấy bản ghi.");

            bool result = await Repository.DeleteAsync(entity, uow);
            return Ok(new { message = "Xóa dữ liệu thành công." });
        }
    }
}