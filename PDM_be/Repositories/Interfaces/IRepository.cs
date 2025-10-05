using System.Data;
using System.Threading.Tasks;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Interfaces;

namespace PDM_be.Repositories.Interfaces
{
    public interface IRepository<TEntity, TPk>
    where TEntity : class where TPk : IComparable
    {
        Task<TPk> SaveOrUpdateAsync(TEntity entity, IUnitOfWork uow);
        Task<TEntity?> GetAsync(TEntity entity, IDbSession uow);
        Task<bool> DeleteAsync(TEntity entity, IUnitOfWork uow);
        Task<TEntity?> GetKeyAsync(TPk id, IDbSession session);
    }
}
