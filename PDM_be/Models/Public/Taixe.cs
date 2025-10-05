using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Public
{
    [Table("tai_xe", Schema = "public")]
    public class Taixe
    {
        [Key]
        public int id { get; set; }
        [StringLength(50)]
        public string ho_ten { get; set; } = string.Empty;
        [StringLength(20)]
        public string? so_dienthoai { get; set; }
        [StringLength(20)]
        public string? bang_lai { get; set; }
    }
}