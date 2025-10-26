import 'package:flutter/material.dart';
import 'package:pdm_app/features/admin/home_admin_screen.dart';
import 'package:pdm_app/features/phuhuynh/home_phuhuynh_screen.dart';
import 'package:pdm_app/features/taixe/home_taixe_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RoleGate extends StatelessWidget {
  const RoleGate({super.key});

  Future<String> getRoleFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole') ?? 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getRoleFromStorage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data!;
        switch (role) {
          case 'admin':
            return const HomeAdminScreen();
          case 'phu_huynh':
            return const HomePhuhuynhScreen();
          case 'tai_xe':
            return const HomeTaixeScreen();
          default:
            // nếu không có role (chưa đăng nhập) thì quay lại Login
            return const LoginScreen();
        }
      },
    );
  }
}
