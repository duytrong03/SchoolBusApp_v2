class XeHienTai {
  int xeId;
  double viDo;
  double kinhDo;
  double? tocDo;
  double? huongDi;
  DateTime capNhat;

  XeHienTai({
    required this.xeId,
    required this.viDo,
    required this.kinhDo,
    this.tocDo,
    this.huongDi,
    required this.capNhat,
  });

  // <-- factory constructor from JSON
  factory XeHienTai.fromJson(Map<String, dynamic> json) {
    return XeHienTai(
      xeId: json['xe_id'],
      viDo: (json['vi_do'] as num).toDouble(),
      kinhDo: (json['kinh_do'] as num).toDouble(),
      tocDo: json['toc_do'] != null ? (json['toc_do'] as num).toDouble() : null,
      huongDi: json['huong_di'] != null ? (json['huong_di'] as num).toDouble() : null,
      capNhat: DateTime.parse(json['cap_nhat']),
    );
  }
}

class XeLichSu {
  int id;
  int xeId;
  double? viDo;
  double? kinhDo;
  double? tocDo;
  double? huongDi;
  DateTime thoiGian;

  XeLichSu({
    required this.id,
    required this.xeId,
    this.viDo,
    this.kinhDo,
    this.tocDo,
    this.huongDi,
    required this.thoiGian,
  });

  factory XeLichSu.fromJson(Map<String, dynamic> json) {
    return XeLichSu(
      id: json['id'],
      xeId: json['xe_id'],
      viDo: json['vi_do'] != null ? (json['vi_do'] as num).toDouble() : null,
      kinhDo: json['kinh_do'] != null ? (json['kinh_do'] as num).toDouble() : null,
      tocDo: json['toc_do'] != null ? (json['toc_do'] as num).toDouble() : null,
      huongDi: json['huong_di'] != null ? (json['huong_di'] as num).toDouble() : null,
      thoiGian: DateTime.parse(json['thoi_gian']),
    );
  }
}

class DiemDon {
  int id;
  int tuyenId;
  String tenDiem;
  double? viDo;
  double? kinhDo;
  int? thuTu;

  DiemDon({
    required this.id,
    required this.tuyenId,
    required this.tenDiem,
    this.viDo,
    this.kinhDo,
    this.thuTu,
  });

  factory DiemDon.fromJson(Map<String, dynamic> json) {
    return DiemDon(
      id: json['id'],
      tuyenId: json['tuyen_id'],
      tenDiem: json['ten_diem'],
      viDo: json['vi_do'] != null ? (json['vi_do'] as num).toDouble() : null,
      kinhDo: json['kinh_do'] != null ? (json['kinh_do'] as num).toDouble() : null,
      thuTu: json['thu_tu'],
    );
  }
}
