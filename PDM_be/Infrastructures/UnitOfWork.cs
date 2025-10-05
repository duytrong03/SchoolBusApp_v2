using System.Data;
using Dapper.FastCrud;
using PDM_be.Infrastructure.Interfaces;

namespace PDM_be.Infrastructure
{
    public class UnitOfWork : IUnitOfWork
    {
        public SqlDialect SqlDialect { get; }
        public IDbTransaction Transaction { get; set; }
        public IDbConnection Connection { get; }
        public IsolationLevel IsolationLevel { get; }

        public UnitOfWork(IDbConnection connection, SqlDialect sqlDialect, IsolationLevel isolationLevel)
        {
            Connection = connection;
            SqlDialect = sqlDialect;
            IsolationLevel = isolationLevel;
            Transaction = connection.BeginTransaction(isolationLevel);
        }

        public void Commit()
        {
            Transaction?.Commit();
            Dispose();
        }

        public void Rollback()
        {
            Transaction?.Rollback();
            Dispose();
        }

        public void Dispose()
        {
            Transaction?.Dispose();
        }
    }

}

// 3️⃣ UnitOfWork – “Gói transaction”

// Vai trò:

// Wrapper cho transaction (IDbTransaction) trên connection.

// Quản lý commit/rollback.

// Nhiệm vụ:

// Mở transaction khi bắt đầu UnitOfWork.

// Commit khi thao tác thành công.

// Rollback khi có lỗi.

// Dispose transaction để tránh rò rỉ.

// Analogy: UnitOfWork giống hộp phiếu giao dịch: bạn cho mọi lệnh vào hộp này → commit = gửi đi, rollback = hủy toàn bộ.