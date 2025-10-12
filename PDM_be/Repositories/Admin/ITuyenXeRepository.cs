using Dapper.FastCrud;
using Npgsql;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models.Public;
using PDM_be.Repositories.Implementations;
using PDM_be.Repositories.Interfaces;
using RepoDb;

namespace PDM_be.Repositories
{
    public interface ITuyenXeRepository : IRepository<TuyenXe, int>
    {
        Task SaveRelationshipAsync(TuyenXe entity, IUnitOfWork uow);
    }

    public class TuyenXeRepository : Repository<TuyenXe, int>, ITuyenXeRepository
    {
        public TuyenXeRepository(IDbFactory dbFactory) : base(dbFactory)
        {
        }

        public override async Task<TuyenXe?> GetKeyAsync(int id, IDbSession session)
        {
            // var entity = await session.Connection.FindAsync<TuyenXe>(stm => stm
            //     .Include<DiemDon>(x => x.LeftOuterJoin())
            //     .Where($"{nameof(TuyenXe.id):C} = @id")
            //     .WithParameters(new { id })
            // );
            // return entity.FirstOrDefault();

            var entity = await session.Connection.GetAsync<TuyenXe>(
                new TuyenXe { id = id },
                stm => stm
                    .Include<DiemDon>(x => x.LeftOuterJoin())
            );
            return entity;
        }

        public async Task SaveRelationshipAsync(TuyenXe entity, IUnitOfWork uow)
        {
            await uow.Connection.BulkDeleteAsync<DiemDon>(x => x
            .Where($@"{nameof(DiemDon.tuyen_id)} = @key AND 
            {(entity?.listDiemDon?.Any(x => x.tuyen_id > 0) == true ?
            $"{nameof(DiemDon.tuyen_id)} <> ALL (@ids)" : "1=1")}")
            .WithParameters(new
            {
                key = entity?.id,
                ids = entity?.listDiemDon?
                        .Where(y => y.tuyen_id > 0)
                        .Select(y => y.tuyen_id)
                        .ToArray() ?? new int[] { }
            }));

            if (entity?.listDiemDon?.Any() == true)
            {
                await (uow.Connection as NpgsqlConnection).BinaryBulkMergeAsync(
                    entity?.listDiemDon.Select(x =>
                    {
                        x.tuyen_id = entity.id;
                        return x;
                    }),

                    transaction: (NpgsqlTransaction?)uow.Transaction,
                    bulkCopyTimeout: 30
                );
            }
        }
    }
}