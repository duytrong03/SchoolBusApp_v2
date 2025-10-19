import 'package:flutter/material.dart';
import '../../admin/home_admin_screen.dart';
import '../../phuhuynh/home_phuhuynh_screen.dart';
import '../../taixe/home_taixe_screen.dart';
class RoleGate extends StatelessWidget {
  const RoleGate({super.key});

  // tạm hardcode để demo
  String getRoleFromToken() {
    return 'admin'; // sau này sẽ parse JWT token hoặc lưu role trong storage
  }

  @override
  Widget build(BuildContext context) {
    final role = getRoleFromToken();
    switch (role) {
      case 'admin':
        return const HomeAdminScreen();
      case 'phuhuynh':
        return const HomePhuhuynhScreen();
      case 'taixe':
        return const HomeTaixeScreen();
      default:
        return const Scaffold(body: Center(child: Text('Không xác định role')));
    }
  }
}
