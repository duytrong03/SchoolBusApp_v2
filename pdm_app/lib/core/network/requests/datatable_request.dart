class DatatableRequest {
  final int draw;
  final int start;
  final int length;
  final String? filterText;

  DatatableRequest({
    this.draw = 0,
    this.start = 0,
    this.length = 100,
    this.filterText,
  });

  Map<String, dynamic> toJson() {
    return {
      "draw": draw,
      "filter": 0,
      "columns": [],
      "order": [],
      "start": start,
      "length": length,
      "search": {
        "value": filterText ?? "",
        "regex": false,
      },
      "filter_text": filterText ?? "",
      "filter_arr": [],
      "filter_str": [],
      "orders": [],
    };
  }
}
