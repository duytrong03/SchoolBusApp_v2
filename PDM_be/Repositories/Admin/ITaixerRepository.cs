using Dapper.FastCrud;
using Npgsql;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models.Public;
using PDM_be.Repositories.Implementations;
using PDM_be.Repositories.Interfaces;
using PDM_be.ViewModels.DTO;
using RepoDb;

namespace PDM_be.Repositories
{
    public interface ITaixeRepository : IRepository<Taixe, int>
    {
    }

    public class TaixeRepository : Repository<Taixe, int>, ITaixeRepository
    {
        public TaixeRepository(IDbFactory dbFactory) : base(dbFactory)
        {
        }

        public override async Task<Taixe?> GetKeyAsync(int id, IDbSession session)
        {

            var entity = await session.Connection.GetAsync<Taixe>(
                new Taixe { id = id }
            );
            return entity;
        }
    }
}