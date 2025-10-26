import 'package:pdm_app/features/admin/hoc_sinh/model/hocsinh_model.dart';

class Lop {
  final int id;
  final String tenLop;
  final String? khoi;
  final String? giaoVienChuNhiem;
  final String? ghiChu;
  final List<HocSinh> listHocSinh;


  Lop({
    required this.id,
    required this.tenLop,
    this.khoi,
    this.giaoVienChuNhiem,
    this.ghiChu,
    this.listHocSinh = const [],
  });

  factory Lop.fromJson(Map<String, dynamic> json) {
    return Lop(
      id: json['id'] ?? 0,
      tenLop: json['ten_lop'] ?? '',
      khoi: json['khoi'] ?? 0,
      giaoVienChuNhiem: json['giaovien_chunhiem'] ?? '',
      ghiChu: json['ghi_chu'] ?? '',
      listHocSinh: (json['listHocSinh'] as List?)
              ?.where((e) => e != null)
              .map((e) => HocSinh.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten_lop': tenLop,
      'khoi': khoi,
      'giaovien_chunhiem': giaoVienChuNhiem,
      'ghi_chu': ghiChu
    };
  }
}
