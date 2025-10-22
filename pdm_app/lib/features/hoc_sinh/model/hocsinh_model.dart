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
    return HocSinh(
      id: json['id'] as int?,
      hoTen: json['ho_ten'] ?? '',
      ngaySinh: json['ngay_sinh'],
      lopId: json['lop_id'] ?? 0,
      lop: json['lop'] != null ? Lop.fromJson(json['lop']) : null,
      ghiChu: json['ghi_chu'],
      maHocSinh: json['ma_hocsinh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ho_ten': hoTen,
      'ngay_sinh': ngaySinh,
      'lop_id': lopId,
      'lop': lop?.toJson(),
      'ghi_chu': ghiChu,
      'ma_hocsinh': maHocSinh,
    };
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
