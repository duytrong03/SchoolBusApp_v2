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
    public interface IDiemDonRepository : IRepository<DiemDon, int>
    {
    }

    public class DiemDonRepository : Repository<DiemDon, int>, IDiemDonRepository
    {
        public DiemDonRepository(IDbFactory dbFactory) : base(dbFactory)
        {
        }

        public override async Task<DiemDon?> GetKeyAsync(int id, IDbSession session)
        {

            var entity = await session.Connection.GetAsync<DiemDon>(
                new DiemDon { id = id },
                stm => stm
                    .Include<TuyenXe>(x => x.LeftOuterJoin())
            );
            return entity;
        }
    }
}