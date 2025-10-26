import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdm_app/features/admin/taixe/data/taixe_service.dart';
import 'package:pdm_app/features/admin/taixe/model/create_driver_model.dart';

class CreateDriverAccountScreen extends StatefulWidget {
  const CreateDriverAccountScreen({super.key});

  @override
  State<CreateDriverAccountScreen> createState() => _CreateDriverAccountScreenState();
}

class _CreateDriverAccountScreenState extends State<CreateDriverAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = TaixeService();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hoTenController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _bangLaiController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final input = CreateDriverModel(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      hoTen: _hoTenController.text.trim(),
      soDienThoai: _soDienThoaiController.text.trim().isEmpty
          ? null
          : _soDienThoaiController.text.trim(),
      bangLai: _bangLaiController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
    );

    setState(() => _isLoading = true);

    try {
      final result = await _service.createDriver(input);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Tạo tài xế thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // báo cho màn danh sách reload
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tạo tài xế: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);

    return Theme(
      data: Theme.of(context).copyWith(textTheme: textTheme),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tạo tài khoản tài xế'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_usernameController, 'Tên đăng nhập', required: true),
                _buildTextField(_passwordController, 'Mật khẩu',
                    obscureText: true, required: true),
                _buildTextField(_hoTenController, 'Họ tên', required: true),
                _buildTextField(_soDienThoaiController, 'Số điện thoại'),
                _buildTextField(_bangLaiController, 'Bằng lái', required: true),
                _buildTextField(_emailController, 'Email'),

                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Tạo tài khoản tài xế'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscureText = false,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.inter(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return '$label không được để trống';
          }
          return null;
        },
      ),
    ).animate(delay: 80.ms).fadeIn(duration: 300.ms);
  }
}
