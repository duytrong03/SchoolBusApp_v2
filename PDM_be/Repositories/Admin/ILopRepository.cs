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
    public interface ILopRepository : IRepository<Lop, int>
    {
    }

    public class LopRepository : Repository<Lop, int>, ILopRepository
    {
        public LopRepository(IDbFactory dbFactory) : base(dbFactory)
        {
        }

        public override async Task<Lop?> GetKeyAsync(int id, IDbSession session)
        {

            var entity = await session.Connection.GetAsync<Lop>(
                new Lop { id = id },
                stm => stm
                    .Include<Hocsinh>(x => x.LeftOuterJoin())
            );
            return entity;
        }
    }
}