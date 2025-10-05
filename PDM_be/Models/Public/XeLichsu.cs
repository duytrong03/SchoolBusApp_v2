using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("xe_lichsu", Schema = "public")]
    public class XeLichsu
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [ForeignKey(nameof(xe))]
        public int xe_id { get; set; }
        public virtual Xe? xe { get; set; }
        public double? vi_do { get; set; }
        public double? kinh_do { get; set; }
        public double? toc_do { get; set; }
        public double? huong_di { get; set; }
        public DateTime thoi_gian { get; set; }
    }
}