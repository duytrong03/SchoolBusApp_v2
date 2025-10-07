using System.ComponentModel.DataAnnotations;

namespace PDM_be.Infrastructure.Identity.ViewModels
{
    public class RegisterParentModel
    {
        [Required(ErrorMessage = "Tên đăng nhập không được để trống")]
        public string? username { get; set; }

        [Required(ErrorMessage = "Mật khẩu không được để trống")]
        public string? password { get; set; }

        [Required(ErrorMessage = "Họ tên không được để trống")]
        public string? ho_ten { get; set; }

        public string? so_dienthoai { get; set; }
        public string? email { get; set; }
    }
}