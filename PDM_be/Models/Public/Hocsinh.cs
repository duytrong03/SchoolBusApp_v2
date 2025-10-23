using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("hoc_sinh", Schema = "public")]
    public class Hocsinh
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [StringLength(100)]
        [Required(ErrorMessage = "Họ và tên không được để trống.")]
        public string ho_ten { get; set; } = string.Empty;
        [StringLength(50)]
        public string? ngay_sinh { get; set; }
        [ForeignKey(nameof(lop))]
        [Required(ErrorMessage = "Lớp không được để trống.")]
        public int lop_id { get; set; }
        public virtual Lop? lop { get; set; }
        [StringLength(256)]
        public string? ghi_chu { get; set; }
        [Required(ErrorMessage = "Mã học sinh không được để trống.")]
        public string ma_hocsinh { get; set; } = string.Empty; 
    }
}