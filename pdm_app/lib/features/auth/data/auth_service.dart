import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/storage_service.dart';

class AuthService {
  final Dio _dio = ApiClient.dio;

  /// Login với username/password
  /// Lưu token vào StorageService nếu login thành công
  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'api/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      final data = response.data;
      if (data != null && data['token'] != null) {
        await StorageService.saveToken(data['token']);
        print('Login thành công, token lưu vào Storage');
        return true;
      }

      print('Login thất bại: token không có trong response');
      return false;
    } on DioException catch (e) {
      print('Login error: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  /// Logout: xóa token
  Future<void> logout() async {
    try {
      // Nếu backend có endpoint logout, gọi ở đây
      // await _dio.post('/auth/logout');
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      await StorageService.clearToken();
      print('Token đã xóa, logout thành công');
    }
  }

  /// Lấy token hiện tại từ StorageService
  static Future<String?> get token async {
    final t = await StorageService.getToken();
    if (t == null) {
      print('Token chưa tồn tại, chưa login');
    }
    return t;
  }

  /// Kiểm tra đã login chưa
  static Future<bool> get isLoggedIn async {
    final t = await token;
    return t != null && t.isNotEmpty;
  }

  /// Thêm header Authorization cho request Dio
  static Future<Map<String, String>> get authHeader async {
    final t = await token;
    if (t == null) throw Exception('Chưa login, token chưa có');
    return {
      'Authorization': 'Bearer $t',
      'Content-Type': 'application/json',
    };
  }
}
