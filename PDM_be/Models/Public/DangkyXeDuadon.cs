using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using PDM_be.Models.Category;

namespace PDM_be.Models.Public
{
    [Table("dangky_xe_duadon", Schema = "public")]
    public class DangkyXeDuadon
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [ForeignKey(nameof(hocsinh))]
        public int hocsinh_id { get; set; }
        public virtual Hocsinh? hocsinh { get; set; }
        [Required]
        public string dia_chi { get; set; } = string.Empty;
        public double? lat { get; set; }
        public double? lon { get; set; }
        [ForeignKey(nameof(loaiDichVu))]
        public int loai_dichvu_id { get; set; }
        public virtual DmLoaiDichvu? loaiDichVu { get; set; }
        public TrangThaiPhanhoi trang_thai { get; set; } = TrangThaiPhanhoi.CHO_DUYET;
        public string? ghi_chu { get; set; }
        public string? quantri_ghichu { get; set; }
    }
}