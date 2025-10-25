using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Map
{
    [Table("map_marker_type", Schema = "map")]
    public class MapMarkerType
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [Required]
        public string code { get; set; } = string.Empty;
        [Required]
        public string name { get; set; } = string.Empty;
        public string? default_icon_url { get; set; }
    }
}