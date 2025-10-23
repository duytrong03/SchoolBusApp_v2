import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdm_app/features/auth/data/auth_service.dart';
import 'package:pdm_app/features/auth/presentation/login_screen.dart';
import 'package:pdm_app/features/hoc_sinh/presentation/hocsinh_management_screen.dart';
import 'package:pdm_app/features/lop/presentation/lop_management_screen.dart';
import 'package:pdm_app/features/taixe/presentation/taixe_management_screen.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _navigateTo(BuildContext context, String feature) {
    if (feature == 'Quản lý lớp học') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LopManagementScreen()),
      );
    } 
    else if (feature == 'Quản lý học sinh') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HocSinhManagementScreen()),
      );
    }
    else if (feature == 'Quản lý tài xế') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TaixeListScreen()),
      );
    }
    else {
      // Tạm thời show SnackBar cho các tính năng khác
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đi tới: $feature')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'title': 'Quản lý lớp học', 'icon': Icons.class_},
      {'title': 'Quản lý học sinh', 'icon': Icons.school},
      {'title': 'Quản lý tài xế', 'icon': Icons.directions_bus},
      {'title': 'Quản lý tài khoản', 'icon': Icons.manage_accounts},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
      title: Text(
        'Trang Quản Trị',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.indigo.shade600,
      iconTheme: const IconThemeData(color: Colors.white), 
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          color: Colors.white, 
          onPressed: () => _logout(context),
          tooltip: 'Đăng xuất',
        ),
      ],
    ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return _AdminCard(
              title: item['title'] as String,
              icon: item['icon'] as IconData,
              onTap: () => _navigateTo(context, item['title'] as String),
            ).animate().fadeIn(delay: (100 * index).ms).scale(duration: 400.ms);
          },
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.indigo.shade600),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
