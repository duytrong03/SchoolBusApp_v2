import 'package:pdm_app/features/lop/model/lop_model.dart';

class HocSinh {
  final int? id;
  final String hoTen;
  final String? ngaySinh;
  final int lopId;
  final Lop? lop;
  final String? ghiChu;
  final String maHocSinh;

  HocSinh({
    this.id,
    required this.hoTen,
    this.ngaySinh,
    required this.lopId,
    this.lop,
    this.ghiChu,
    required this.maHocSinh,
  });

  factory HocSinh.fromJson(Map<String, dynamic> json) {
    final lopData = json['lop'];

    Lop? lopObj;
    if (lopData is Map<String, dynamic>) {
      lopObj = Lop.fromJson(lopData);
    } else {
      lopObj = null; // an toàn nếu API không trả object
    }

    return HocSinh(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      hoTen: json['ho_ten'] ?? '',
      ngaySinh: json['ngay_sinh'],
      lopId: json['lop_id'] ?? 0,
      lop: lopObj,
      ghiChu: json['ghi_chu'],
      maHocSinh: json['ma_hocsinh'] ?? '',
    );
  }

  Map<String, dynamic> toJson({bool forUpdate = false}) {
    final map = {
      'ho_ten': hoTen,
      'ngay_sinh': ngaySinh,
      'lop_id': lopId,
      'ghi_chu': ghiChu,
      'ma_hocsinh': maHocSinh,
    };
    if (forUpdate && id != null) map['id'] = id; // chỉ gửi id khi update
    return map;
  }

  HocSinh copyWith({
    int? id,
    String? hoTen,
    String? ngaySinh,
    int? lopId,
    Lop? lop,
    String? ghiChu,
    String? maHocSinh,
  }) {
    return HocSinh(
      id: id ?? this.id,
      hoTen: hoTen ?? this.hoTen,
      ngaySinh: ngaySinh ?? this.ngaySinh,
      lopId: lopId ?? this.lopId,
      lop: lop ?? this.lop,
      ghiChu: ghiChu ?? this.ghiChu,
      maHocSinh: maHocSinh ?? this.maHocSinh,
    );  
  }
}
