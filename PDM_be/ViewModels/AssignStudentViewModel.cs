using System.ComponentModel.DataAnnotations;

namespace PDM_be.ViewModels
{
    public class AssignStudentRequest
    {
        public int phuhuynh_id { get; set; }
        [Required]
        public string ma_hocsinh { get; set; } = string.Empty;
        public string? username { get; set; }
        public string? ho_ten { get; set; }
    }
}