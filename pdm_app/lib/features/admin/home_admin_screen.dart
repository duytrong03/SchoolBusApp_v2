import 'package:flutter/material.dart';
import 'package:pdm_app/features/auth/data/auth_service.dart';
import 'package:pdm_app/features/auth/presentation/login_screen.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();

    // Quay về màn hình login, xóa toàn bộ navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang quản trị'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Xin chào Admin!'),
      ),
    );
  }
}
