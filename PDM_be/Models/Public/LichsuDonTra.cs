using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using PDM_be.Models.Category;

namespace PDM_be.Models.Public
{
    [Table("lichsu_dontra", Schema = "public")]
    public class LichsuDonTra
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        public int hocsinh_id { get; set; }
        public int tuyen_id { get; set; }
        [ForeignKey(nameof(trangThai))]
        public string? trangthai_id { get; set; }
        public virtual TrangthaiDonTra? trangThai { get; set; }
    }
}