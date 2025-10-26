import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pdm_app/features/taixe/model/map_model.dart';

class ApiService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}api';

  Future<List<XeHienTai>> getXeHienTai() async {
    final uri = Uri.parse('$baseUrl/xe-hientai');
    print('Connecting to: $uri');

    final body = {
      "draw": 1,
      "start": 0,
      "length": 10,
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List data = jsonData['data'];
      return data.map((e) => XeHienTai.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load XeHienTai: ${response.statusCode}');
    }
  }

  Future<List<XeLichSu>> getXeLichSu(int xeId) async {
    final uri = Uri.parse('$baseUrl/xe-lichsu');
    print('Connecting to: $uri');

    final body = {
      "draw": 1,
      "start": 0,
      "length": 10,
      "xe_id": xeId,
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List data = jsonData['data'];
      return data.map((e) => XeLichSu.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load XeLichSu: ${response.statusCode}');
    }
  }

  Future<List<DiemDon>> getDiemDon() async {
    final uri = Uri.parse('$baseUrl/diem-don/datatable');
    print('Connecting to: $uri');

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "draw": 1,
          "start": 0,
          "length": 10,
        }),
      );

      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];

        final list = data
            .where((e) => e != null && e['vi_do'] != null && e['kinh_do'] != null)
            .map((e) => DiemDon.fromJson(e))
            .toList();

        print('Tổng điểm đón: ${list.length}');
        for (final item in list) {
          print(' ${item.tenDiem} (${item.viDo}, ${item.kinhDo})');
        }

        return list;
      } else {
        print('Lỗi server: ${response.body}');
        return [];
      }
    } catch (e, s) {
      print('Lỗi kết nối API: $e');
      print(s);
      return [];
    }
  }


  Future<void> updateLocation(XeLocationViewModel dto) async {
    final uri = Uri.parse('$baseUrl/update-location');
    final body = {
      "xe_id": dto.xeId,
      "vi_do": dto.viDo,
      "kinh_do": dto.kinhDo,
      "toc_do": dto.tocDo,
      "huong_di": dto.huongDi,
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Cập nhật vị trí thành công');
    } else {
      throw Exception(
          'Failed to update location: ${response.statusCode} ${response.body}');
    }
  }
}
class XeLocationViewModel {
  int xeId;
  double viDo;
  double kinhDo;
  double? tocDo;
  double? huongDi;

  XeLocationViewModel({
    required this.xeId,
    required this.viDo,
    required this.kinhDo,
    this.tocDo,
    this.huongDi,
  });

  Map<String, dynamic> toJson() {
    return {
      "xe_id": xeId,
      "vi_do": viDo,
      "kinh_do": kinhDo,
      if (tocDo != null) "toc_do": tocDo,
      if (huongDi != null) "huong_di": huongDi,
    };
  }
}
