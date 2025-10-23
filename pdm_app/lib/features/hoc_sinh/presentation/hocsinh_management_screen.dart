import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdm_app/features/hoc_sinh/data/hocsinh_service.dart';
import 'package:pdm_app/features/hoc_sinh/model/hocsinh_model.dart';
import 'package:pdm_app/features/lop/data/lop_service.dart';
import 'package:pdm_app/features/lop/model/lop_model.dart';

class HocSinhManagementScreen extends StatefulWidget {
  const HocSinhManagementScreen({super.key});

  @override
  State<HocSinhManagementScreen> createState() => _HocSinhManagementScreenState();
}

class _HocSinhManagementScreenState extends State<HocSinhManagementScreen> {
  final HocsinhService _hocSinhService = HocsinhService();
  final LopService _lopService = LopService();

  late Future<List<HocSinh>> _futureHocSinh;
  late Future<List<Lop>> _futureLops;
  int? _selectedLopId; // lọc theo lớp

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _futureHocSinh = _hocSinhService.getAll();
    _futureLops = _lopService.getAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadData();
    });
  }

  // 📋 Form thêm/sửa học sinh
  void _showForm({HocSinh? hocSinh}) async {
    final formKey = GlobalKey<FormState>();
    final hoTenController = TextEditingController(text: hocSinh?.hoTen ?? '');
    final ngaySinhController = TextEditingController(text: hocSinh?.ngaySinh ?? '');
    final maHocSinhController = TextEditingController(text: hocSinh?.maHocSinh ?? '');
    final ghiChuController = TextEditingController(text: hocSinh?.ghiChu ?? '');
    int? selectedLopId = hocSinh?.lopId;

    final lops = await _lopService.getAll();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          hocSinh == null ? 'Thêm học sinh' : 'Cập nhật học sinh',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Họ tên - Required
                TextFormField(
                  controller: hoTenController,
                  decoration: const InputDecoration(labelText: 'Họ tên'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Họ tên không được để trống';
                    }
                    if (value.length > 100) {
                      return 'Họ tên không quá 100 ký tự';
                    }
                    return null;
                  },
                ),
                // Ngày sinh - optional
                TextFormField(
                  controller: ngaySinhController,
                  decoration: const InputDecoration(labelText: 'Ngày sinh'),
                ),
                // Mã học sinh - Required
                TextFormField(
                  controller: maHocSinhController,
                  decoration: const InputDecoration(labelText: 'Mã học sinh'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mã học sinh không được để trống';
                    }
                    return null;
                  },
                ),
                // Lớp - Required
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Lớp'),
                  initialValue: selectedLopId,
                  items: lops
                      .map((lop) => DropdownMenuItem<int>(
                            value: lop.id,
                            child: Text(lop.tenLop),
                          ))
                      .toList(),
                  onChanged: (v) => selectedLopId = v,
                  validator: (value) {
                    if (value == null) return 'Vui lòng chọn lớp';
                    return null;
                  },
                ),
                // Ghi chú - optional
                TextFormField(
                  controller: ghiChuController,
                  decoration: const InputDecoration(labelText: 'Ghi chú'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton.icon(
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('Lưu', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (formKey.currentState?.validate() != true) return;

              final newHS = HocSinh(
                id: hocSinh?.id,
                hoTen: hoTenController.text.trim(),
                ngaySinh: ngaySinhController.text.trim(),
                lopId: selectedLopId!,
                ghiChu: ghiChuController.text.trim(),
                maHocSinh: maHocSinhController.text.trim(),
              );

              try {
                if (hocSinh == null) {
                  await _hocSinhService.create(newHS);
                } else {
                  await _hocSinhService.update(newHS);
                }
                Navigator.pop(context);
                _refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(hocSinh == null ? 'Đã thêm học sinh mới!' : 'Đã cập nhật học sinh!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi lưu dữ liệu: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ❌ Xóa học sinh
  Future<void> _deleteHocSinh(HocSinh hocSinh) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa học sinh "${hocSinh.hoTen}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _hocSinhService.delete(hocSinh);
        _refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa học sinh thành công!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi xóa dữ liệu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade600,
        title: Text(
          'Quản lý học sinh',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          FutureBuilder<List<Lop>>(
          future: _futureLops,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final lops = snapshot.data!;

            return Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.indigo.shade700,
                textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.white)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedLopId,
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  hint: const Text('Lọc theo lớp', style: TextStyle(color: Colors.white)),
                  items: lops
                      .map((lop) => DropdownMenuItem<int>(
                            value: lop.id,
                            child: Text(lop.tenLop, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedLopId = v;
                    });
                  },
                ),
              ),
            );
          },
        ),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo.shade600,
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm học sinh', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<HocSinh>>(
        future: _futureHocSinh,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi tải dữ liệu: ${snapshot.error}',
                  style: GoogleFonts.montserrat(color: Colors.red)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Chưa có học sinh nào',
                  style: GoogleFonts.montserrat(color: Colors.grey.shade600)),
            );
          }

          // Lọc theo lớp
          final allHocSinh = snapshot.data!;
          final filtered = _selectedLopId == null
              ? allHocSinh
              : allHocSinh.where((hs) => hs.lopId == _selectedLopId).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                'Không có học sinh trong lớp đã chọn',
                style: GoogleFonts.montserrat(color: Colors.grey.shade600),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final hs = filtered[index];
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: const Icon(Icons.person, color: Colors.indigo),
                    ),
                    title: Text(
                      hs.hoTen,
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Lớp: ${hs.lop?.tenLop ?? hs.lopId} • Ngày sinh: ${hs.ngaySinh ?? '---'}',
                      style: GoogleFonts.montserrat(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () => _showForm(hocSinh: hs),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteHocSinh(hs),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: (100 * index).ms)
                    .slideY(begin: 0.1, duration: 400.ms);
              },
            ),
          );
        },
      ),
    );
  }
}

class HocSinhService {
}
