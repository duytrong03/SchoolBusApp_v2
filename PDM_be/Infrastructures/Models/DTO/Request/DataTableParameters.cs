namespace PDM_be.Infrastructure.DTO.Request
{
    public class DatatableParameters
    {
        public int draw { get; set; }

        public int filter { get; set; }

        public List<Column>? columns { get; set; }

        public List<Order>? order { get; set; }

        public int start { get; set; }

        public int length { get; set; }

        public Search? search { get; set; }

        public string? filter_text { get; set; }

        public int[]? filter_arr { get; set; }

        public string[]? filter_str { get; set; }
    }
}