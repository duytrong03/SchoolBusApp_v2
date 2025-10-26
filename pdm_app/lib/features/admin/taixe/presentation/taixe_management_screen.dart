import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdm_app/features/admin/taixe/data/taixe_service.dart';
import 'package:pdm_app/features/admin/taixe/model/taixe_model.dart';
import 'package:pdm_app/features/admin/taixe/presentation/create_driver_account_screen.dart';
import 'package:pdm_app/features/admin/taixe/presentation/taixe_detail_dialog.dart';

class TaixeListScreen extends StatefulWidget {
  const TaixeListScreen({super.key});

  @override
  State<TaixeListScreen> createState() => _TaixeListScreenState();
}

class _TaixeListScreenState extends State<TaixeListScreen> {
  final _service = TaixeService();
  late Future<List<Taixe>> _futureTaixe;

  @override
  void initState() {
    super.initState();
    _futureTaixe = _service.getAll();
  }

  Future<void> _reload() async {
    setState(() {
      _futureTaixe = _service.getAll();
    });
  }

  void _openDetailPopup(int id) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TaixeDetailDialog(id: id).animate().fade(duration: 300.ms),
    );
  }

  void _openCreateDriverAccount() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateDriverAccountScreen(),
      ),
    );
    if (result == true) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);

    return Theme(
      data: Theme.of(context).copyWith(textTheme: textTheme),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Quản lý tài xế',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _openCreateDriverAccount,
              icon: const Icon(Icons.person_add_rounded),
              tooltip: 'Tạo tài khoản tài xế',
            ),
          ],
        ),
        body: FutureBuilder<List<Taixe>>(
          future: _futureTaixe,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Lỗi tải dữ liệu: ${snapshot.error}',
                  style: GoogleFonts.inter(color: Colors.redAccent),
                ),
              );
            }

            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return const Center(child: Text('Chưa có tài xế nào'));
            }

            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final tx = list[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.shade100,
                        child: Text(
                          tx.hoTen.isNotEmpty ? tx.hoTen[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        tx.hoTen,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(tx.soDienThoai ?? 'Không có SĐT'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onTap: () => _openDetailPopup(tx.id),
                    ),
                  ).animate(delay: (index * 80).ms).fadeIn(duration: 350.ms).slideX(begin: 0.1);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
