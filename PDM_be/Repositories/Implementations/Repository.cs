using Dapper.FastCrud;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Repositories.Interfaces;

namespace PDM_be.Repositories.Implementations
{
    public class Repository<TEntity, TPk> : IRepository<TEntity, TPk>
        where TEntity : class
        where TPk : IComparable
    {
        private readonly IDbFactory _dbFactory;
        public Repository(IDbFactory dbFactory) => _dbFactory = dbFactory;

        protected IDbSession OpenSession()
        {
            return _dbFactory.Create<DbSession>();
        }

        public virtual async Task<TPk> SaveOrUpdateAsync(TEntity entity, IUnitOfWork uow)
        {
            if (entity == null)
                throw new ArgumentNullException(nameof(entity));

            if (uow == null)
                throw new ArgumentNullException(nameof(uow));

            var conn = uow.Connection;
            var tx = uow.Transaction;

            var keyProp = typeof(TEntity).GetProperty("id")
                  ?? throw new InvalidOperationException("Entity must have id property");

            var keyValue = keyProp.GetValue(entity);

            if (keyValue == null || keyValue.Equals(default(TPk)))
            {
                // Insert
                await conn.InsertAsync(entity, s => s.AttachToTransaction(tx));
                keyValue = keyProp.GetValue(entity); // lấy Id mới sinh
            }
            else
            {
                // Update
                await conn.UpdateAsync(entity, s => s.AttachToTransaction(tx));
            }

            return (TPk)keyValue!;
        }


        public virtual async Task<TEntity?> GetKeyAsync(TPk id, IDbSession session)
        {
            if (id == null) throw new ArgumentNullException(nameof(id));
            if (session == null) throw new ArgumentNullException(nameof(session));

            // Tạo instance entity và gán giá trị primary key
            var entity = Activator.CreateInstance<TEntity>();
            var keyProp = typeof(TEntity).GetProperty("id")
                        ?? throw new InvalidOperationException("Entity must have id property");
            keyProp.SetValue(entity, id);
            // Dùng session.Connection để Get entity
            return await session.Connection.GetAsync(entity);
        }

        public virtual async Task<TEntity?> GetAsync(TEntity entity, IDbSession session)
        {
            if (entity == null) throw new ArgumentNullException(nameof(entity));
            if (session == null) throw new ArgumentNullException(nameof(session));
            return await session.Connection.GetAsync(entity);
        }

        public virtual async Task<bool> DeleteAsync(TEntity entity, IUnitOfWork uow)
        {
            if (entity == null) throw new ArgumentNullException(nameof(entity));
            if (uow == null) throw new ArgumentNullException(nameof(uow));

            var conn = uow.Connection;
            var tx = uow.Transaction;

            var deleted = await conn.DeleteAsync(entity, s => s.AttachToTransaction(tx));
            return deleted; 
        }
    }
}