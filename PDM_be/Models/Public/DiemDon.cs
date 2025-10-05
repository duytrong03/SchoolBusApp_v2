using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("diem_don", Schema = "public")]
    public class DiemDon
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [ForeignKey(nameof(tuyen))]
        public int tuyen_id { get; set; }
        public virtual TuyenXe? tuyen { get; set; }
        [StringLength(100)]
        public string ten_diem { get; set; } = string.Empty;
        public double? vi_do { get; set; }
        public double? kinh_do { get; set; }
        public int? thu_tu { get; set; }
    }
}