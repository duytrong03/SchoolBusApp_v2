using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("lop", Schema = "public")]
    public class Lop
    {
        [Key]
        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [StringLength(50)]
        [Required]
        public string ten_lop { get; set; } = string.Empty;
        [StringLength(1)]
        public string? khoi { get; set; }
        [StringLength(100)]
        public string? giaovien_chunhiem { get; set; }
        [StringLength(256)]
        public string? ghi_chu { get; set; }

        // public virtual IEnumerable<Hocsinh>? listHocSinh { get; set; }
    }
}