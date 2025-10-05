using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models
{
    [Table("tai_khoan", Schema = "public")]
    public class TaiKhoan
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        [Required]
        [StringLength(50)]
        public string username { get; set; } = string.Empty;

        [Required]
        public string password_hash { get; set; } = string.Empty;

        [Required]
        [StringLength(20)]
        public string role { get; set; } = string.Empty;

        [StringLength(100)]
        public string? ho_ten { get; set; }

        [StringLength(20)]
        public string? so_dienthoai { get; set; }

        [StringLength(100)]
        public string? email { get; set; }

        public DateTime created_at { get; set; }
    }
}