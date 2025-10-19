import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl{
    if (Platform.isAndroid)
    {
      return dotenv.env['API_BASE_URL_EMULATOR']!;
    }
    return dotenv.env['API_BASE_URL_LOCAL']!;
  }
}