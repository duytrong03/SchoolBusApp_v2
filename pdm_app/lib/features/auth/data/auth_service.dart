import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/storage_service.dart';

class AuthService {
  final _dio = ApiClient.dio;

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post('api/auth/login', data: {
        'username': username,
        'password': password,
      });

      final data = response.data;
      if (data != null && data['token'] != null) {
        await StorageService.saveToken(data['token']);
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Login error: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Nếu backend có endpoint logout, gọi ở đây:
      // await _dio.post('/auth/logout');
    } catch (e) {
      print('⚠️ Logout API error: $e');
    } finally {
      await StorageService.clearToken();
    }
  }
}
