using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("tuyen_xe", Schema = "public")]
    public class TuyenXe
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [StringLength(100)]
        [Required]
        public string ten_tuyen { get; set; } = string.Empty;
        public TimeSpan? gio_batdau { get; set; }
        public TimeSpan? gio_ketthuc { get; set; }
        [ForeignKey(nameof(taixe))]
        public int taixe_id { get; set; }
        public virtual Taixe? taixe { get; set; }
        [ForeignKey(nameof(xe))]
        public int xe_id { get; set; }
        public virtual Xe? xe { get; set; }

        public virtual IEnumerable<DiemDon>? listDiemDon { get; set; }
    }
}