using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Category
{
    [Table("trangthai_dontra", Schema = "public")]
    public class TrangthaiDonTra
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [StringLength(256)]
        public string? mo_ta { get; set; }
    }
}