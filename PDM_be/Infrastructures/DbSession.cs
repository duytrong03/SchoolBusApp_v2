using System.Data;
using Dapper.FastCrud;
using PDM_be.Infrastructure.Interfaces;

namespace PDM_be.Infrastructure
{
    public class DbSession : IDbSession
    {
        public IDbConnection Connection { get; }
        public SqlDialect SqlDialect { get; }

        public DbSession(IDbConnection connection, SqlDialect sqlDialect)
        {
            Connection = connection ?? throw new ArgumentNullException(nameof(connection));
            SqlDialect = sqlDialect;
        }

        public IUnitOfWork UnitOfWork()
        {
            return new UnitOfWork(Connection, SqlDialect, IsolationLevel.RepeatableRead);
        }

        public IUnitOfWork UnitOfWork(IsolationLevel isolationLevel)
        {
            return new UnitOfWork(Connection, SqlDialect, isolationLevel);
        }

        public void Dispose()
        {
            Connection?.Dispose();
        }
    }
}

// 2️⃣ DbSession – “Phiên làm việc với DB”

// Vai trò:

// Wrapper cho connection thực tế (IDbConnection).

// Biết SQL dialect (SqlDialect) để Dapper.FastCrud tạo SQL đúng.

// Có thể sinh ra UnitOfWork khi cần transaction.

// Nhiệm vụ:

// Giữ kết nối (Connection) mở và quản lý lifecycle của nó.

// Cung cấp phương thức tạo transaction (UnitOfWork()).

// Dispose connection khi xong.

// Analogy: DbSession giống bàn làm việc trong cửa hàng: bạn ngồi vào bàn này để thao tác DB,
// muốn làm việc an toàn thì mở transaction (UnitOfWork)