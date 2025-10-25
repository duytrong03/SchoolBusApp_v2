using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Category
{
    [Table("dm_loai_dichvu", Schema = "public")]
    public class DmLoaiDichvu
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [StringLength(256)]
        public string? mo_ta { get; set; }
        public string? ghi_chu { get; set; }
    }
}