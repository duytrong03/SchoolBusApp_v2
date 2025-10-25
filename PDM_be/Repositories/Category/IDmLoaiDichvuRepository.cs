using Dapper.FastCrud;
using Npgsql;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models.Category;
using PDM_be.Models.Public;
using PDM_be.Repositories.Implementations;
using PDM_be.Repositories.Interfaces;
using PDM_be.ViewModels.DTO;
using RepoDb;

namespace PDM_be.Repositories
{
    public interface IDmLoaiDichvuRepository : IRepository<DmLoaiDichvu, int>
    {
    }

    public class DmLoaiDichvuRepository : Repository<DmLoaiDichvu, int>, IDmLoaiDichvuRepository
    {
        public DmLoaiDichvuRepository(IDbFactory dbFactory) : base(dbFactory)
        {
        }
    }
}