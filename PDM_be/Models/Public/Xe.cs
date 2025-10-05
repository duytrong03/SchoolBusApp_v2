using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("xe", Schema = "public")]
    public class Xe
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [StringLength(20)]
        [Required]
        public string bien_so { get; set; } = string.Empty;
        [StringLength(10)]
        public string? so_chongoi { get; set; }
        [StringLength(20)]
        public string? trang_thai { get; set; }
    }
}