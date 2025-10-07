using System.ComponentModel.DataAnnotations;

namespace PDM_be.Infrastructure.Identity.ViewModels
{
    public class CreateDriverModel
    {
        [Required]
        public string? username { get; set; }

        [Required]
        public string? password { get; set; }

        [Required]
        public string? ho_ten { get; set; }

        public string? so_dienthoai { get; set; }

        [Required]
        public string? bang_lai { get; set; }
        public string? email { get; set; }
    }
}