import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdm_app/features/auth/data/auth_service.dart';
import 'package:pdm_app/features/auth/presentation/role_gate.dart';
import '../../../core/utils/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool isLoading = false;
  final _auth = AuthService();

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);
    final ok = await _auth.login(usernameCtrl.text, passwordCtrl.text);
    setState(() => isLoading = false);

    if (ok) {
      final token = await StorageService.getToken();
      final role = await StorageService.getRole();
      debugPrint('Token: $token, Role: $role');

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleGate()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            'assets/images/background_app.jpg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          // Nội dung đăng nhập
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: Colors.white)
                      .animate()
                      .fade(duration: 600.ms)
                      .scale(),
                  const SizedBox(height: 20),
                  Text(
                    'Chào mừng trở lại!',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ).animate().fade(duration: 600.ms).slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'Đăng nhập để tiếp tục',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ).animate().fade(duration: 700.ms).slideY(begin: 0.4, end: 0),
                  const SizedBox(height: 40),
                  TextField(
                    controller: usernameCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Tài khoản',
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.white70, width: 0.5),
                      ),
                    ),
                  ).animate().fade(duration: 800.ms).slideY(begin: 0.5, end: 0),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.white70, width: 0.5),
                      ),
                    ),
                  ).animate().fade(duration: 900.ms).slideY(begin: 0.6, end: 0),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              'Đăng nhập',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                    ),
                  ).animate().fade(duration: 1000.ms).slideY(begin: 0.7, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
