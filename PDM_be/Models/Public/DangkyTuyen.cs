using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("dangky_tuyen", Schema = "public")]
    public class DangkyTuyen
    {
        [Key]
        [Required]
        [ForeignKey(nameof(hocSinh))]
        public int hocsinh_id { get; set; }
        public virtual Hocsinh? hocSinh { get; set; }

        [Key]
        [Required]
        [ForeignKey(nameof(tuyen))]
        public int tuyen_id { get; set; }
        public virtual TuyenXe? tuyen { get; set; }
    }
}