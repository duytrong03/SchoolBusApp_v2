  import 'package:flutter/material.dart';
  import 'package:pdm_app/features/auth/presentation/role_gate.dart';
  import '../data/auth_service.dart';
  import '../../../core/utils/storage_service.dart';

  class LoginScreen extends StatefulWidget{
    const LoginScreen({super.key});
    @override
    State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    bool isLoading = false;
    final _auth = AuthService();

    Future<void> _handleLogin() async {
      setState(() => isLoading = true);
      final ok = await _auth.login(usernameCtrl.text, passwordCtrl.text);
      setState(() => isLoading = false);

      if (ok) {
        final token = await StorageService.getToken();
        print('Token: $token');
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RoleGate()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại')),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đăng nhập')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'Tài khoản')),
              TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Mật khẩu'), obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _handleLogin,
                child: isLoading ? const CircularProgressIndicator() : const Text('Đăng nhập'),
              ),
            ],
          ),
        ),
      );
    }
  }