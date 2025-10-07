using Microsoft.AspNetCore.Mvc;
using PDM_be.Infrastructure;
using PDM_be.Infrastructure.Abstractions;
using PDM_be.Infrastructure.Interfaces;
using PDM_be.Models.Public;
using PDM_be.Repositories.Interfaces;

namespace PDM_be.Controllers
{
    [ApiController]
    [Route("api/hoc-sinh")]
    public class HocsinhController : BaseApiCRUDController<DbSession,Hocsinh, int>
    {
        public HocsinhController(IDbFactory dbFactory, IRepository<Hocsinh, int> repository) 
        : base(dbFactory, repository)
        {
        }
    }
}