import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pdm_app/features/auth/presentation/splash_screen.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  String? baseUrl;
  if (kIsWeb)
  {
    baseUrl = dotenv.env['API_BASE_URL_LOCAL'];
  }
  else if (Platform.isAndroid)
  {
    baseUrl = dotenv.env['API_BASE_URL_EMULATOR'];
  }
  else
  {
    baseUrl = dotenv.env['API_BASE_URL_LOCAL'];
  }

  debugPrint('Running on: ${kIsWeb ? "Web" : Platform.operatingSystem}');
  debugPrint('API_BASE_URL = $baseUrl');
  dotenv.env['API_BASE_URL'] = baseUrl!;
  runApp(const MyApp());
}

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
