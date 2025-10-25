using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PDM_be.Models.Map
{
    [Table("map_marker", Schema = "map")]
    public class MapMarker
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        [Required]
        public string ten_marker { get; set; } = string.Empty;
        public string? mo_ta { get; set; }
        [ForeignKey(nameof(type))]
        public int type_id { get; set; }
        public virtual MapMarkerType? type { get; set; }
        [Required]
        public double? lat { get; set; }
        [Required]
        public double? lon { get; set; }
        public string? icon_url { get; set; }
        public string? color { get; set; }
        public bool? active { get; set; }
        public string? meta { get; set; }
        public DateTime created_at { get; set; } = DateTime.Now;
        public DateTime updated_at { get; set; } = DateTime.Now;
    }
}