import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:pdm_app/features/auth/data/auth_service.dart';
import 'package:pdm_app/features/auth/presentation/login_screen.dart';
import 'package:pdm_app/features/taixe/bando/map_screen_taixe.dart';

class HomeTaixeScreen extends StatelessWidget {
  const HomeTaixeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(
          'Trang chủ Tài xế',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header chào tài xế
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào, Tài xế!',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chúc bạn một ngày an toàn và thuận lợi!',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Lottie.asset(
                      'assets/animations/driver-hello.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

            const SizedBox(height: 24),

            // Thông tin tổng quan
            Text(
              'Tổng quan hôm nay',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard(
                  icon: FontAwesomeIcons.route,
                  label: 'Chuyến đi',
                  value: '5',
                  color: Colors.orange,
                ),
                _infoCard(
                  icon: FontAwesomeIcons.sackDollar,
                  label: 'Thu nhập',
                  value: '450.000đ',
                  color: Colors.green,
                ),
                _infoCard(
                  icon: FontAwesomeIcons.gasPump,
                  label: 'Nhiên liệu',
                  value: '80%',
                  color: Colors.blue,
                ),
              ],
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),

            const SizedBox(height: 30),

            // Hành động nhanh
            Text(
              'Hành động nhanh',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _actionButton(
                  context,
                  icon: FontAwesomeIcons.locationDot,
                  color: Colors.blue,
                  label: 'Xem bản đồ',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapScreenTaixe()),
                    );
                  },
                ),
                _actionButton(
                  context,
                  icon: FontAwesomeIcons.clock,
                  color: Colors.orange,
                  label: 'Lịch trình',
                  onTap: () {},
                ),
                _actionButton(
                  context,
                  icon: FontAwesomeIcons.bell,
                  color: Colors.green,
                  label: 'Thông báo',
                  onTap: () {},
                ),
                _actionButton(
                  context,
                  icon: FontAwesomeIcons.userGear,
                  color: Colors.purple,
                  label: 'Cài đặt',
                  onTap: () {},
                ),
              ],
            ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
