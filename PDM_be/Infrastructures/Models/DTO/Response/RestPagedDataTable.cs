namespace PDM_be.Infrastructure.DTO.Response
{
    public class RestPagedDataTable<T>
    {
        public T? data { get; set; }

        public int draw { get; set; }

        public int totalPages { get; set; }

        public int recordsFiltered { get; set; }

        public int recordsTotal { get; set; }

    }
}