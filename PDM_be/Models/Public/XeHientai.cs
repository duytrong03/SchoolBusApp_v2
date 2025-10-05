using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("xe_hientai", Schema = "public")]
    public class XeHientai
    {
        [Key]
        [Required]
        [ForeignKey(nameof(xe))]
        public int xe_id { get; set; }
        public virtual Xe? xe { get; set; }
        [Required]
        public double vi_do { get; set; }
        [Required]
        public double kinh_do { get; set; }
        public double? toc_do { get; set; }
        public double? huong_di { get; set; }
        public DateTime cap_nhat { get; set; }
    }
}