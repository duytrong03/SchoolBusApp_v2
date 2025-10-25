using System.ComponentModel.DataAnnotations;

namespace PDM_be.ViewModels
{
    public class DangKyXeDuadonViewModel
    {
        [Required]
        public string ma_hocsinh { get; set; } = string.Empty;
        [Required]
        public string dia_chi { get; set; } = string.Empty;
        public double? lat { get; set; }
        public double? lon { get; set; }
        public int loai_dichvu_id { get; set; }
        public string? ghi_chu { get; set; }
    }
}