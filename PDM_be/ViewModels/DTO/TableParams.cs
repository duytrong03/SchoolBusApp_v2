using System.Data;
using PDM_be.Infrastructure.DTO.Request;
namespace PDM_be.ViewModels.DTO
{
    public class TableParameters : DatatableParameters
    {
        /// <summary>
        /// số bản ghi trên 1 trang
        /// tương tự "leghth" như datatables.net
        /// </summary>
        // public int pageSize { get; set; } = 10;
        /// <summary>
        /// trang hiện tại
        /// </summary>
        // public int currentPage { get; set; } = 1;
        /// <summary>
        /// Tìm kiếm từ khóa
        /// </summary>
        // public string? keyword { get; set; }
        public IEnumerable<TabLeSortOrder>? orders { get; set; }
    }

    public class TabLeSortOrder
    {
        /// <summary>
        /// Tên trường dữ liệu sắp xếp
        /// </summary>
        public string prop { get; set; } = string.Empty;
        /// <summary>
        /// Kiểu sắp xếp: ascending/descending
        /// </summary>
        public string order { get; set; } = string.Empty;
    }
}