using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using PDM_be.Models.Public;

namespace PDM_be.Models.Category
{
    [Table("phuhuynh_hocsinh", Schema = "public")]
    public class PhuhuynhHocsinh
    {
        [Key]
        [Required]
        [ForeignKey(nameof(phuHuynh))]
        public int phuhuynh_id { get; set; }
        public virtual TaiKhoan? phuHuynh { get; set; }

        [Key]
        [Required]
        [ForeignKey(nameof(hocSinh))]
        public int hocsinh_id { get; set; }
        public virtual Hocsinh? hocSinh { get; set; }
    }
}