import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pdm_app/core/utils/storage_service.dart';
import 'package:pdm_app/features/admin/taixe/model/create_driver_model.dart';
import 'package:pdm_app/features/admin/taixe/model/taixe_model.dart';

class TaixeService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}api/tai-xe';
  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('Chưa login, token chưa có');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Taixe>> getAll() async {
    final uri = Uri.parse('$baseUrl/datatable');
    print('Connecting to: $uri');

    final body = {
      "draw": 1,
      "start": 0,
      "length": 10,
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
      print('Loaded ${data.length} Tài xế');
      return data.map((e) => Taixe.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Tài xế: ${response.statusCode}');
    }
  }

  Future<Taixe> getById(int id) async {
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

        if (data == null) throw Exception('Không tìm thấy tài xế có ID $id');

        return Taixe.fromJson(data); 
      } else {
        throw Exception('Failed to fetch tài xế: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi tải tài xế ID $id: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createDriver(CreateDriverModel input) async {
    final uri = Uri.parse(baseUrl);
    print('[CREATE] Gửi yêu cầu tạo tài xế: $uri');

    final bodyJson = jsonEncode(input.toJson());
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Tạo tài xế thành công: $jsonResponse');
        return jsonResponse;
      } else if (response.statusCode == 400) {
        throw Exception('Dữ liệu không hợp lệ: ${response.body}');
      } else if (response.statusCode == 401) {
        throw Exception('Token hết hạn hoặc không hợp lệ.');
      } else {
        throw Exception('Tạo tài xế thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi tạo tài xế: $e');
      rethrow;
    }
  }

  Future<void> update(Taixe taiXe) async {
    final uri = Uri.parse(baseUrl);
    print('[UPDATE] Gửi yêu cầu cập nhật lớp: $uri');

    final bodyJson = jsonEncode(taiXe.toJson());
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
        print('Cập nhật tài xế thành công!');
      } else if (response.statusCode == 401) {
        print('Token hết hạn hoặc không hợp lệ.');
        throw Exception('Token hết hạn hoặc không hợp lệ.');
      } else if (response.statusCode == 404) {
        print('Không tìm thấy tài xế cần cập nhật.');
        throw Exception('Không tìm thấy tài xế cần cập nhật.');
      } else {
        throw Exception('Cập nhật thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi cập nhật tài xế: $e');
      rethrow;
    }
  }

  Future<void> delete(Taixe taiXe) async {
    final uri = Uri.parse(baseUrl);
    print('[DELETE] Gửi yêu cầu xóa tài xế qua body: $uri');

    final bodyJson = jsonEncode(taiXe.toJson());
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
        print('Xóa tài xế thành công!');
      } else if (response.statusCode == 401) {
        throw Exception('Token hết hạn hoặc không hợp lệ.');
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy tài xế cần xóa.');
      } else {
        throw Exception('Xóa thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi xóa tài xế: $e');
      rethrow;
    }
  }
}