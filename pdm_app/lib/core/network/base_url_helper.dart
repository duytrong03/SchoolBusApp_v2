import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BaseUrlHelper {
  static Future<String> detectBaseUrl() async {
    final urls = [
      dotenv.env['API_BASE_URL_EMULATOR'],
      dotenv.env['API_BASE_URL_LOCAL'],
    ].whereType<String>();

    for (final url in urls) {
      final pingUrl = url.endsWith('/')
          ? '${url}api/ping'
          : '$url/api/ping'; // luôn kiểm tra đúng route

      try {
        final res = await http
            .get(Uri.parse(pingUrl))
            .timeout(const Duration(seconds: 2));

        if (res.statusCode == 200) {
          print('Connected to $url');
          return url;
        }
      } catch (e) {
        print('Không thể kết nối $pingUrl: $e');
      }
    }

    throw Exception('Không tìm thấy server khả dụng');
  }
}