using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Interfaces;

namespace PDM_be.Controllers.Public
{
    [Route("api/public")]
    [ApiController]

    public partial class PublicApiController : ControllerBase
    {
        private readonly IDbFactory _dbFactory;
        public PublicApiController(IDbFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }
        protected IDbSession OpenSession()
        {
            return _dbFactory.Create<DbSession>();
        }
    }
}