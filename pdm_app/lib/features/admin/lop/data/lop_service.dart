import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pdm_app/core/utils/storage_service.dart';
import 'package:pdm_app/features/admin/lop/model/lop_model.dart';

class LopService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}api/lop';
  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('Chưa login, token chưa có');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Lop>> getAll({String? khoi}) async {
    final uri = Uri.parse('$baseUrl/datatable');
    print('Connecting to: $uri');

    final body = {
      "draw": 1,
      "start": 0,
      "length": 50, // hoặc tăng lên nếu muốn lấy hết
      if (khoi != null && khoi.isNotEmpty) "khoi": khoi,
    };

    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List data = jsonData['data'];
      print('Loaded ${data.length} lớp');
      return data.map((e) => Lop.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load lớp: ${response.statusCode}');
    }
  }

  /// Lấy lớp theo ID
  Future<Lop> getById(int id) async {
    final uri = Uri.parse('$baseUrl/$id');
    print('Get lớp by ID: $uri');

    try {
      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data']; 

        if (data == null) throw Exception('Không tìm thấy lớp có ID $id');

        return Lop.fromJson(data); 
      } else {
        throw Exception('Failed to fetch lớp: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi tải lớp ID $id: $e');
      rethrow;
    }
  }

  /// Tạo lớp mới
  Future<void> create(Lop lop) async {
    final uri = Uri.parse(baseUrl);
    print('[CREATE] Gửi yêu cầu tạo lớp: $uri');

    // In ra body gửi đi
    final bodyJson = jsonEncode(lop.toJson());
    print('Body gửi đi: $bodyJson');

    try {
      final headers = await _getHeaders();
      print('Headers: $headers');

      final response = await http.post(
        uri,
        headers: headers,
        body: bodyJson,
      );

      print('Status: ${response.statusCode}');
      print('Body phản hồi: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Tạo lớp thành công!');
      } else if (response.statusCode == 401) {
        print('Token không hợp lệ hoặc hết hạn.');
        throw Exception('Token hết hạn hoặc không hợp lệ.');
      } else {
        throw Exception('Tạo lớp thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi tạo lớp: $e');
      rethrow;
    }
  }

  /// Cập nhật lớp
  Future<void> update(Lop lop) async {
    final uri = Uri.parse(baseUrl);
    print('[UPDATE] Gửi yêu cầu cập nhật lớp: $uri');

    final bodyJson = jsonEncode(lop.toJson());
    print('Body gửi đi: $bodyJson');

    try {
      final headers = await _getHeaders();
      print('Headers: $headers');

      final response = await http.put(
        uri,
        headers: headers,
        body: bodyJson,
      );

      print('Status: ${response.statusCode}');
      print('Body phản hồi: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Cập nhật lớp thành công!');
      } else if (response.statusCode == 401) {
        print('Token hết hạn hoặc không hợp lệ.');
        throw Exception('Token hết hạn hoặc không hợp lệ.');
      } else if (response.statusCode == 404) {
        print('Không tìm thấy lớp cần cập nhật.');
        throw Exception('Không tìm thấy lớp cần cập nhật.');
      } else {
        throw Exception('Cập nhật thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi cập nhật lớp: $e');
      rethrow;
    }
  }

  /// Xóa lớp
  Future<void> delete(Lop lop) async {
    final uri = Uri.parse(baseUrl);
    print('[DELETE] Gửi yêu cầu xóa lớp qua body: $uri');

    final bodyJson = jsonEncode(lop.toJson());
    print('Body gửi đi: $bodyJson');

    try {
      final headers = await _getHeaders();
      print('Headers: $headers');

      final response = await http.delete(
        uri,
        headers: headers,
        body: bodyJson,
      );

      print('Status: ${response.statusCode}');
      print('Body phản hồi: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Xóa lớp thành công!');
      } else if (response.statusCode == 401) {
        throw Exception('Token hết hạn hoặc không hợp lệ.');
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy lớp cần xóa.');
      } else {
        throw Exception('Xóa thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi xóa lớp: $e');
      rethrow;
    }
  }

}