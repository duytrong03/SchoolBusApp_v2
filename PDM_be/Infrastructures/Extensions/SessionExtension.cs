// using System.Data;
// using Dapper;
// using Dapper.FastCrud;
// using Dapper.FastCrud.Configuration.StatementOptions.Builders;
// using PDM_be.Infrastructure.Interfaces;

// namespace PDM_be.Infrastructure.Extensions
// {
//     public static class SessionExtensions
//     {
//         public static IDbTransaction BeginTransaction(this IDbSession session, IsolationLevel il)
//         {
//             if (session.Connection.State != ConnectionState.Open)
//                 session.Connection.Open();
//             return session.Connection.BeginTransaction(il);
//         }

//         public static IEnumerable<dynamic> Query(this IDbSession session, string sql, object? param = null, IDbTransaction? transaction = null, bool buffered = true, int? commandTimeout = null, CommandType? commandType = null)
//         {
//             return session.Connection.Query(sql, param, transaction, buffered, commandTimeout, commandType);
//         }

//         public static IEnumerable<T> Query<T>(this IDbSession session, string sql, object? param = null, IDbTransaction? transaction = null, bool buffered = true, int? commandTimeout = null, CommandType? commandType = null)
//         {
//             return session.Connection.Query<T>(sql, param, transaction, buffered, commandTimeout, commandType);
//         }

//         public static Task<IEnumerable<T>> QueryAsync<T>(this IDbSession session, string sql, object? param = null, IDbTransaction? transaction = null, int? commandTimeout = null, CommandType? commandType = null)
//         {
//             return session.Connection.QueryAsync<T>(sql, param, transaction, commandTimeout, commandType);
//         }

//         public static Task<int> ExecuteAsync(this IDbSession session, string sql, object? param = null, IDbTransaction? transaction = null, int? commandTimeout = null, CommandType? commandType = null)
//         {
//             return session.Connection.ExecuteAsync(sql, param, transaction, commandTimeout, commandType);
//         }

//         public static int Execute(this IDbSession session, string sql, object? param = null, IDbTransaction? transaction = null, int? commandTimeout = null, CommandType? commandType = null)
//         {
//             return session.Connection.Execute(sql, param, transaction, commandTimeout, commandType);
//         }

//         public static int BulkDelete<TEntity>(this IDbSession session, Action<IConditionalBulkSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return session.Connection.BulkDelete(statementOptions);
//         }

//         public static async Task<int> BulkDeleteAsync<TEntity>(this IDbSession session, Action<IConditionalBulkSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return await session.Connection.BulkDeleteAsync(statementOptions);
//         }

//         public static int BulkUpdate<TEntity>(this IDbSession session, TEntity updateData, Action<IConditionalBulkSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return session.Connection.BulkUpdate(updateData, statementOptions);
//         }

//         public static async Task<int> BulkUpdateAsync<TEntity>(this IDbSession session, TEntity updateData, Action<IConditionalBulkSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return await session.Connection.BulkUpdateAsync(updateData, statementOptions);
//         }

//         public static int Count<TEntity>(this IDbSession session, Action<IConditionalSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return session.Connection.Count(statementOptions);
//         }

//         public static async Task<int> CountAsync<TEntity>(this IDbSession session, Action<IConditionalSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return await session.Connection.CountAsync(statementOptions);
//         }

//         public static bool Delete<TEntity>(this IDbSession session, TEntity entityToDelete, Action<IStandardSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return session.Connection.Delete(entityToDelete, statementOptions);
//         }

//         public static async Task<bool> DeleteAsync<TEntity>(this IDbSession session, TEntity entityToDelete, Action<IStandardSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return await session.Connection.DeleteAsync(entityToDelete, statementOptions);
//         }

//         public static IEnumerable<TEntity> Find<TEntity>(this IDbSession session, Action<IRangedBatchSelectSqlSqlStatementOptionsOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return session.Connection.Find(statementOptions);
//         }

//         public static async Task<IEnumerable<TEntity>> FindAsync<TEntity>(this IDbSession session, Action<IRangedBatchSelectSqlSqlStatementOptionsOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return await session.Connection.FindAsync(statementOptions);
//         }

//         public static TEntity Get<TEntity>(this IDbSession session, TEntity entityKeys, Action<ISelectSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return session.Connection.Get(entityKeys, statementOptions);
//         }

//         public static async Task<TEntity> GetAsync<TEntity>(this IDbSession session, TEntity entityKeys, Action<ISelectSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return await session.Connection.GetAsync(entityKeys, statementOptions);
//         }

//         public static void Insert<TEntity>(this IDbSession session, TEntity entityToInsert, Action<IStandardSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             session.Connection.Insert(entityToInsert, statementOptions);
//         }

//         public static async Task InsertAsync<TEntity>(this IDbSession session, TEntity entityToInsert, Action<IStandardSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             await session.Connection.InsertAsync(entityToInsert, statementOptions);
//         }

//         public static bool Update<TEntity>(this IDbSession session, TEntity entityToUpdate, Action<IStandardSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return session.Connection.Update(entityToUpdate, statementOptions);
//         }

//         public static async Task<bool> UpdateAsync<TEntity>(this IDbSession session, TEntity entityToUpdate, Action<IStandardSqlStatementOptionsBuilder<TEntity>> statementOptions = null) where TEntity : class
//         {
//             return await session.Connection.UpdateAsync(entityToUpdate, statementOptions);
//         }        
//     }
// }