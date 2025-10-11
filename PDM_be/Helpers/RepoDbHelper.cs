using System.Linq.Expressions;
using RepoDb;

namespace PDM_be.Helpers
{
    public static class RepoDBHepler
    {
        public static string OnlyTableName<TEntity>() where TEntity : class
        {
            return ClassMappedNameCache.Get<TEntity>().Split(".").Last();
        }
        public static string FullColumnName<TEntity>(Expression<Func<TEntity, object>> propertyExpression) where TEntity : class
        {
            return $"{ClassMappedNameCache.Get<TEntity>()}.{PropertyMappedNameCache.Get(propertyExpression)}";
        }
    }
}