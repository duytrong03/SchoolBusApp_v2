using Dapper.FastCrud;
using Npgsql;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models.Map;
using PDM_be.Models.Public;
using PDM_be.Repositories.Implementations;
using PDM_be.Repositories.Interfaces;
using PDM_be.ViewModels.DTO;
using RepoDb;

namespace PDM_be.Repositories
{
    public interface IMapRepository : IRepository<MapMarker, int>
    {
    }

    public class MapRepository : Repository<MapMarker, int>, IMapRepository
    {
        public MapRepository(IDbFactory dbFactory) : base(dbFactory)
        {
        }

        public override async Task<MapMarker?> GetKeyAsync(int id, IDbSession session)
        {

            var entity = await session.Connection.GetAsync<MapMarker>(
                new MapMarker { id = id }
            );
            return entity;
        }
    }
}