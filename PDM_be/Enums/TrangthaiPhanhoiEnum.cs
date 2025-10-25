using System.ComponentModel.DataAnnotations;

public enum TrangThaiPhanhoi
{
    [Display(Name = "Chờ duyệt")]
    CHO_DUYET = 0,
    
    [Display(Name = "Đã duyệt")]
    DA_DUYET = 1,
    
    [Display(Name = "Từ chối")]
    TU_CHOI = 2
}