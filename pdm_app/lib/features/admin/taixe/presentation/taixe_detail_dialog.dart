import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdm_app/features/admin/taixe/data/taixe_service.dart';
import 'package:pdm_app/features/admin/taixe/model/taixe_model.dart';

class TaixeDetailDialog extends StatefulWidget {
  final int id;

  const TaixeDetailDialog({super.key, required this.id});

  @override
  State<TaixeDetailDialog> createState() => _TaixeDetailDialogState();
}

class _TaixeDetailDialogState extends State<TaixeDetailDialog> {
  final _service = TaixeService();
  late Future<Taixe> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _service.getById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<Taixe>(
          future: _futureDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.red));
            }

            if (!snapshot.hasData) {
              return const Text('Không có dữ liệu tài xế');
            }

            final tx = snapshot.data!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chi tiết tài xế',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 12),
                _infoRow('Họ tên', tx.hoTen),
                _infoRow('Số điện thoại', tx.soDienThoai ?? 'Chưa có'),
                _infoRow('Bằng lái', tx.bangLai ?? 'Chưa có'),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Đóng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ).animate().scale(duration: 250.ms),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }
}
