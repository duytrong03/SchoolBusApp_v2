import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:pdm_app/features/auth/presentation/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load file .env
  await dotenv.load(fileName: ".env");

  // Lấy URL phù hợp
  String baseUrl = await _determineBaseUrl();

  debugPrint('Running on: ${kIsWeb ? "Web" : Platform.operatingSystem}');
  debugPrint('API_BASE_URL = $baseUrl');

  // Cập nhật giá trị để dùng ở các nơi khác
  dotenv.env['API_BASE_URL'] = baseUrl;

  runApp(const MyApp());
}

/// Hàm xác định môi trường và chọn base URL
Future<String> _determineBaseUrl() async {
  if (kIsWeb) {
    return dotenv.env['API_BASE_URL_LOCAL'] ?? '';
  }

  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.isPhysicalDevice == false) {
      // Emulator
      return dotenv.env['API_BASE_URL_EMULATOR'] ?? '';
    } else {
      // Thiết bị thật - thay vì dò IP máy điện thoại, dùng IP máy BE
      return dotenv.env['API_BASE_URL_LOCAL'] ?? '';
    }
  }

  // Mặc định cho iOS hoặc desktop
  return dotenv.env['API_BASE_URL_LOCAL'] ?? '';
}

/// Hàm tự động dò IP LAN của máy tính
Future<String> _getLocalIp() async {
  try {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLinkLocal: false,
    );

    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.address.startsWith('192.') || addr.address.startsWith('10.')) {
          return addr.address;
        }
      }
    }

    debugPrint('Không tìm thấy IP LAN, fallback localhost');
    return '127.0.0.1';
  } catch (e) {
    debugPrint('Lỗi khi dò IP LAN: $e');
    return '127.0.0.1';
  }
}

/// Ứng dụng chính
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Bus App',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
