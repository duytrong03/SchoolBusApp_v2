import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pdm_app/core/utils/storage_service.dart';
import 'package:pdm_app/features/admin/hoc_sinh/model/hocsinh_model.dart';

class HocsinhService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}api/hoc-sinh';

  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('Chưa login, token chưa có');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<List<HocSinh>> getAll() async {
    final uri = Uri.parse('$baseUrl/datatable');
    print('Connecting to: $uri');

    final body = {
      "draw": 1,
      "start": 0,
      "length": 50,
    };

    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load học sinh: ${response.statusCode}');
    }

    // decode an toàn
    final jsonData = jsonDecode(response.body);
    final rawData = jsonData['data'];

    if (rawData == null) {
      print('API trả về data = null, trả về danh sách rỗng.');
      return <HocSinh>[];
    }

    if (rawData is! List) {
      throw Exception('Unexpected data format from API: expected List, got ${rawData.runtimeType}');
    }

    final List list = rawData;
    final result = <HocSinh>[];
    for (final e in list) {
      if (e == null) continue;
      if (e is Map<String, dynamic>) {
        result.add(HocSinh.fromJson(e));
      } else if (e is Map) {
        // sometimes jsonDecode gives Map<dynamic, dynamic>
        result.add(HocSinh.fromJson(Map<String, dynamic>.from(e)));
      } else {
        print('Bỏ qua item không phù hợp: ${e.runtimeType}');
      }
    }

    print('Loaded ${result.length} học sinh');
    return result;
  }

  Future<HocSinh> getById(int id) async {
    final uri = Uri.parse('$baseUrl/$id');
    print('Get học sinh by ID: $uri');

    final response = await http.get(uri, headers: await _getHeaders());

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch học sinh: ${response.statusCode}');
    }

    final jsonData = jsonDecode(response.body);
    final data = jsonData['data'];

    if (data == null) {
      throw Exception('Không tìm thấy học sinh có ID $id (data == null)');
    }
    if (data is! Map) {
      throw Exception('Unexpected data format for getById: ${data.runtimeType}');
    }

    return HocSinh.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> create(HocSinh hocSinh) async {
    final uri = Uri.parse(baseUrl);
    print('[CREATE] Gửi yêu cầu tạo học sinh: $uri');

    final bodyJson = jsonEncode(hocSinh.toJson(forUpdate: hocSinh.id != null));
    print('Body gửi đi: $bodyJson');

    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: bodyJson,
    );

    print('Status: ${response.statusCode}');
    print('Body phản hồi: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Tạo học sinh thất bại: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> update(HocSinh hocSinh) async {
    final uri = Uri.parse(baseUrl);
    print('[UPDATE] Gửi yêu cầu cập nhật học sinh: $uri');

    final bodyJson = jsonEncode(hocSinh.toJson(forUpdate: hocSinh.id != null));
    print('Body gửi đi: $bodyJson');

    final response = await http.put(
      uri,
      headers: await _getHeaders(),
      body: bodyJson,
    );

    print('Status: ${response.statusCode}');
    print('Body phản hồi: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Cập nhật thất bại: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> delete(HocSinh hocSinh) async {
    final uri = Uri.parse(baseUrl);
    print('[DELETE] Gửi yêu cầu xóa học sinh qua body: $uri');

    final bodyJson = jsonEncode(hocSinh.toJson(forUpdate: hocSinh.id != null));
    print('Body gửi đi: $bodyJson');

    final response = await http.delete(
      uri,
      headers: await _getHeaders(),
      body: bodyJson,
    );

    print('Status: ${response.statusCode}');
    print('Body phản hồi: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Xóa thất bại: ${response.statusCode} - ${response.body}');
    }
  }
}
