namespace PDM_be.Infrastructure.DTO.Request
{
    public class Order
    {
        public int column { get; set; }

        public string dir { get; set; } = "asc";
    }
}