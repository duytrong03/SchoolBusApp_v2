using System.Data;
using Dapper.FastCrud;

namespace PDM_be.Infrastructure.Interfaces
{
    public interface IDbSession : IDisposable
    {
        IDbConnection Connection { get; }
        SqlDialect SqlDialect { get; }
        IUnitOfWork UnitOfWork();
        IUnitOfWork UnitOfWork(IsolationLevel isolationLevel);
    }
}

// IDbSession: phải có Connection, SqlDialect, UnitOfWork().

// Mục đích:

// Đại diện cho một kết nối tới database (thường wrap quanh NpgsqlConnection, SqlConnection…).

// Cho phép tạo UnitOfWork để bắt đầu transaction.

// Giữ thông tin về SqlDialect (Dapper.FastCrud cần biết bạn đang dùng PostgreSQL, SQL Server, MySQL…).