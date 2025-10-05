using System.Data;
using Dapper.FastCrud;

namespace PDM_be.Infrastructure.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        SqlDialect SqlDialect { get; }

        IDbTransaction Transaction { get; set; }

        IDbConnection Connection { get; }

        IsolationLevel IsolationLevel { get; }

        void Commit();

        void Rollback();
    }
}

// IUnitOfWork: phải có Transaction, Commit, Rollback.

// 2. IUnitOfWork – Quản lý Transaction

// Mục đích:

// Bao bọc transaction (IDbTransaction).

// Cho phép Commit hoặc Rollback khi làm nhiều thao tác DB.

// Hỗ trợ IsolationLevel (độ cách ly transaction, ví dụ ReadCommitted, RepeatableRead).

// 👉 Nói dễ hiểu: IUnitOfWork giống như phiếu giao dịch trong ngân hàng:

// Nếu mọi lệnh thành công → Commit().

// Nếu có lỗi → Rollback().

