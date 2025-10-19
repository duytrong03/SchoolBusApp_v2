import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BaseUrlHelper {
  static Future<String> detectBaseUrl() async
  {
    final urls = [
      dotenv.env['API_BASE_URL_EMULATOR'],
      dotenv.env['API_BASE_URL_LOCAL']
    ].whereType<String>();
    for (final url in urls)
    {
      try {
        final res = await http.get(Uri.parse('$url/ping')).timeout(const Duration(seconds: 1));
        if (res.statusCode == 200) {
          print('Connected to $url');
          return url;
        }
      }catch (_){}
    }
    throw Exception('Không tìm thấy server khả dụng');
  }
}