using System.ComponentModel.DataAnnotations;

namespace PDM_be.Infrastructure.Identity.ViewModels
{
    public class LoginInputModel
    {
        [Required(ErrorMessage = "Tài khoản không được để trống")]
        public string? username { get; set; }

        [Required(ErrorMessage = "Mật khẩu không được để trống")]
        public string? password { get; set; }

        public bool rememberLogin { get; set; }

        public string? returnUrl { get; set; }

        public LoginInputModel()
        {
            rememberLogin = true;
        }
    }
}