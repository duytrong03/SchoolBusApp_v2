import 'package:pdm_app/features/hoc_sinh/model/hocsinh_model.dart';

class Lop {
  final int id;
  final String tenLop;
  final String? khoi;
  final String? giaoVienChuNhiem;
  final List<HocSinh> listHocSinh;


  Lop({
    required this.id,
    required this.tenLop,
    this.khoi,
    this.giaoVienChuNhiem,
    this.listHocSinh = const [],
  });

  factory Lop.fromJson(Map<String, dynamic> json) {
    return Lop(
      id: json['id'],
      tenLop: json['ten_lop'],
      khoi: json['khoi'],
      giaoVienChuNhiem: json['giaovien_chunhiem'],
      listHocSinh: (json['listHocSinh'] as List?)
              ?.map((e) => HocSinh.fromJson(e))
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
    };
  }
}
