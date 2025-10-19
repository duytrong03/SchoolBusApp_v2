import 'package:dio/dio.dart';
import 'package:pdm_app/core/network/api_config.dart';
import 'package:pdm_app/core/utils/storage_service.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await StorageService.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            print('Lỗi khi lấy token: $e');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // print('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (e, handler) {
          print('API Error: ${e.message}');
          if (e.response != null) {
            print('Status code: ${e.response?.statusCode}');
            print('Response data: ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );

  // Hàm GET
  static Future<Response> get(String path,
      {Map<String, dynamic>? query}) async {
    try {
      return await dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Hàm POST
  static Future<Response> post(String path, dynamic data) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Hàm PUT
  static Future<Response> put(String path, dynamic data) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Hàm DELETE
  static Future<Response> delete(String path, dynamic data) async {
    try {
      return await dio.delete(
        path,
        data: data, 
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Hàm xử lý lỗi chuẩn
  static String _handleError(DioException e) {
    if (e.response != null) {
      return "Lỗi server (${e.response?.statusCode}): ${e.response?.statusMessage}";
    } else {
      return "Không thể kết nối đến server. Kiểm tra lại mạng.";
    }
  }
}
