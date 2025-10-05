using System.Data;
using Dapper.FastCrud;
using Npgsql;
using PDM_be.Infrastructure.Interfaces;

namespace PDM_be.Infrastructure
{
    public class DbFactory : IDbFactory
    {
        private readonly string _connectionString;
        public DbFactory(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection")
                ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found");
        }

        public T Create<T>() where T : class, IDbSession
        {
            var connection = new NpgsqlConnection(_connectionString);
            connection.Open();

            // Khởi tạo session (ví dụ: NpgsqlSession phải implement IDbSession)
            var session = Activator.CreateInstance(typeof(T), connection, SqlDialect.PostgreSql)
                as T;

            if (session == null)
                throw new InvalidOperationException($"Không tạo được session {typeof(T).Name}");

            return session;
        }

        // Tạo UnitOfWork dựa trên Session
        public TUnitOfWork Create<TUnitOfWork, TSession>(
            IsolationLevel isolationLevel = IsolationLevel.RepeatableRead)
            where TUnitOfWork : class, IUnitOfWork
            where TSession : class, IDbSession
        {
            // Tạo session trước
            var session = Create<TSession>();

            // Tạo unit of work
            var uow = Activator.CreateInstance(
                typeof(TUnitOfWork),
                session.Connection,
                session.SqlDialect,
                isolationLevel
            ) as TUnitOfWork;

            if (uow == null)
                throw new InvalidOperationException($"Không tạo được UnitOfWork {typeof(TUnitOfWork).Name}");

            return uow;
        }

        public void Release(IDisposable instance)
        {
            instance?.Dispose();
        }
    }
}

// 1️⃣ DbFactory – “Nhà máy tạo DB resources”

// Vai trò:

// Là trung tâm để tạo session và unit of work.

// Giữ connection string, quyết định loại DB (PostgreSQL, SQL Server…).

// Dùng trong Dependency Injection để service không cần biết chi tiết DB.

// Nhiệm vụ:

// Tạo IDbSession → trả connection + dialect.

// Tạo IUnitOfWork → trả transaction đã gắn vào connection.

// Giải phóng tài nguyên (Release()).

// Analogy: DbFactory giống cửa hàng: bạn vào lấy Session/UnitOfWork, cửa hàng lo việc chuẩn bị cho bạn.

//////////////////////////////////////////////////////////////////////////////////////////////////////

// Service/Repository
//         │
//         ▼
//     DbFactory.Create<DbSession>()
//         │
//         ▼
//     DbSession.Connection (mở kết nối)
//         │
//         ▼
//     DbSession.UnitOfWork() 
//         │
//         ▼
//     UnitOfWork.Transaction (begin transaction)
//         │
//     Thực hiện nhiều lệnh SQL
//         │
//         ▼
//     uow.Commit() hoặc uow.Rollback()