import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdm_app/features/lop/data/lop_service.dart';
import 'package:pdm_app/features/lop/model/lop_model.dart';

class LopManagementScreen extends StatefulWidget {
  const LopManagementScreen({super.key});

  @override
  State<LopManagementScreen> createState() => _LopManagementScreenState();
}

class _LopManagementScreenState extends State<LopManagementScreen> {
  final LopService _service = LopService();
  late Future<List<Lop>> _futureLops;
  String? _selectedKhoi; // Khối được chọn để lọc (1, 2, 3, 4, 5)

  @override
  void initState() {
    super.initState();
    _loadLops();
  }
  void _showHocSinhPopup(int lopId, String tenLop) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FutureBuilder<Lop>(
          future: _service.getById(lopId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Lỗi tải danh sách học sinh:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            final lop = snapshot.data!;
            final hocSinhList = lop.listHocSinh;

            return SafeArea(
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.75,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Column(
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Text(
                        'Danh sách học sinh - $tenLop',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: hocSinhList.isEmpty
                            ? Center(
                                child: Text(
                                  'Chưa có học sinh trong lớp này',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: hocSinhList.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final hs = hocSinhList[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.indigo.shade100,
                                      child: const Icon(Icons.person,
                                          color: Colors.indigo),
                                    ),
                                    title: Text(
                                      hs.hoTen,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Ngày sinh: ${hs.ngaySinh ?? '---'}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    trailing: Text(
                                      hs.maHocSinh.isEmpty
                                          ? '---'
                                          : hs.maHocSinh,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.indigo.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _loadLops() {
    _futureLops = _service.getAll();
    _futureLops.then((value) {
      print('Loaded ${value.length} lớp');
    }).catchError((e) {
      print('Error loading lớp: $e');
    });
  }

  void _showForm({Lop? lop}) {
    final tenController = TextEditingController(text: lop?.tenLop ?? '');
    final khoiController = TextEditingController(text: lop?.khoi ?? '');
    final gvController = TextEditingController(text: lop?.giaoVienChuNhiem ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          lop == null ? 'Thêm lớp học' : 'Cập nhật lớp học',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: tenController, decoration: const InputDecoration(labelText: 'Tên lớp')),
              TextField(controller: khoiController, decoration: const InputDecoration(labelText: 'Khối')),
              TextField(controller: gvController, decoration: const InputDecoration(labelText: 'Giáo viên chủ nhiệm')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('Lưu', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              final newLop = Lop(
                id: lop?.id ?? 0,
                tenLop: tenController.text.trim(),
                khoi: khoiController.text.trim(),
                giaoVienChuNhiem: gvController.text.trim(),
              );

              try {
                if (lop == null) {
                  await _service.create(newLop);
                } else {
                  await _service.update(newLop);
                }
                _loadLops();
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(lop == null ? 'Đã thêm lớp mới!' : 'Đã cập nhật lớp!')),
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

  Future<void> _deleteLop(Lop lop) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa lớp "${lop.tenLop}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.delete(lop);
        _loadLops();
        setState(() {});
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
          'Quản lý lớp học',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Gói DropdownButton trong Theme để đổi màu text trong popup
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.indigo.shade700, // nền popup
              textTheme: const TextTheme(
                titleMedium: TextStyle(color: Colors.white), // chữ trắng trong popup
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedKhoi,
                icon: const Icon(Icons.filter_list, color: Colors.white),
                hint: const Text(
                  'Chọn khối',
                  style: TextStyle(color: Colors.white),
                ),
                items: ['1', '2', '3', '4', '5']
                    .map(
                      (k) => DropdownMenuItem(
                        value: k,
                        child: Text(
                          'Khối $k',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKhoi = value;
                  });
                },
                style: const TextStyle(
                  color: Colors.white, // chữ của khối được chọn
                ),
                dropdownColor: Colors.indigo.shade700, // màu popup đồng bộ
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo.shade600,
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm lớp', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Lop>>(
        future: _futureLops,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi tải dữ liệu: ${snapshot.error}',
                style: GoogleFonts.montserrat(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Chưa có lớp học nào',
                style: GoogleFonts.montserrat(color: Colors.grey.shade600),
              ),
            );
          }

          // Lọc dữ liệu theo khối nếu có chọn
          final allLops = snapshot.data!;
          final filteredLops = _selectedKhoi == null
              ? allLops
              : allLops.where((l) => l.khoi == _selectedKhoi).toList();

          if (filteredLops.isEmpty) {
            return Center(
              child: Text(
                'Không có lớp trong khối $_selectedKhoi',
                style: GoogleFonts.montserrat(color: Colors.grey.shade600),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredLops.length,
            itemBuilder: (context, index) {
              final lop = filteredLops[index];
              return Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(
                      lop.khoi ?? '?',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                  title: Text(
                    lop.tenLop,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Text(
                    lop.giaoVienChuNhiem ?? 'Chưa có GVCN',
                    style: GoogleFonts.montserrat(color: Colors.grey.shade600),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () => _showForm(lop: lop),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteLop(lop),
                      ),
                    ],
                  ),
                  // 👇 Thêm dòng này để mở popup xem học sinh
                  onTap: () => _showHocSinhPopup(lop.id, lop.tenLop),
                ),
              )
                  .animate()
                  .fadeIn(delay: (100 * index).ms)
                  .slideY(begin: 0.1, duration: 400.ms);
            },
          );
        },
      ),
    );
  }
}
