class Taixe {
  final int id;
  final String hoTen;
  final String? soDienThoai;
  final String? bangLai;

  Taixe({
    required this.id,
    required this.hoTen,
    this.soDienThoai,
    this.bangLai,
  });

  factory Taixe.fromJson(Map<String, dynamic> json) {
    return Taixe(
      id: json['id'] as int,
      hoTen: json['ho_ten'] ?? '',
      soDienThoai: json['so_dienthoai'],
      bangLai: json['bang_lai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ho_ten': hoTen,
      'so_dienthoai': soDienThoai,
      'bang_lai': bangLai,
    };
  }
}
