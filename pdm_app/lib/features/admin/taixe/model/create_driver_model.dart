class CreateDriverModel {
  final String username;
  final String password;
  final String hoTen;
  final String? soDienThoai;
  final String bangLai;
  final String? email;

  CreateDriverModel({
    required this.username,
    required this.password,
    required this.hoTen,
    this.soDienThoai,
    required this.bangLai,
    this.email,
  });

  factory CreateDriverModel.fromJson(Map<String, dynamic> json) {
    return CreateDriverModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      hoTen: json['ho_ten'] ?? '',
      soDienThoai: json['so_dienthoai'],
      bangLai: json['bang_lai'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'ho_ten': hoTen,
      'so_dienthoai': soDienThoai,
      'bang_lai': bangLai,
      'email': email,
    };
  }
}
