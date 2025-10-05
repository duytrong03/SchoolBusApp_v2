using System.Data;

namespace PDM_be.Infrastructure.Interfaces
{
    public interface IDbFactory
    {
        // Tạo session
        T Create<T>() where T : class, IDbSession;

        // Tạo unit of work từ session
        TUnitOfWork Create<TUnitOfWork, TSession>(
            IsolationLevel isolationLevel = IsolationLevel.RepeatableRead
        )
            where TUnitOfWork : class, IUnitOfWork
            where TSession : class, IDbSession;

        // Giải phóng resource
        void Release(IDisposable instance);
    }
}

// IDbFactory: xác định bạn phải có Create<T>(), Create<TUnitOfWork,TSession>(), Release().

// 3. IDbFactory – Nhà máy sản xuất Session & UnitOfWork

// Mục đích:

// Chuẩn hóa cách tạo ra Session và UnitOfWork.

// Tránh để service hoặc repository tự tạo connection/transaction → dễ sai, khó test.

// Cho phép Dependency Injection (inject IDbFactory vào service → gọi Create<T>() khi cần).

// 👉 Nói dễ hiểu: IDbFactory giống như cái máy ATM:

// Bạn muốn rút tiền (Session) → Create<T>().

// Bạn muốn thực hiện giao dịch có kiểm soát (UnitOfWork) → Create<TUnitOfWork, TSession>().

// Khi xong thì Release() để đóng kết nối.

// Nó chỉ nói: “bất kỳ DbSession nào cũng phải có Connection, SqlDialect, UnitOfWork() và Dispose()”.

// Không quan tâm bạn dùng Npgsql, SQL Server hay fake connection.