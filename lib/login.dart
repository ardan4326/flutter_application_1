import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  // Terhubung ke backend di htdocs Apache/XAMPP
  // Jika folder backend berbeda, sesuaikan path di sini
  final String _loginUrl = 'http://localhost/backend/login.php';

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final resp = await http.post(
        Uri.parse(_loginUrl),
        body: {'email': email, 'password': password},
      ).timeout(const Duration(seconds: 10));

      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data['success'] == true) {
          final userEmail = data['user']?['email'] ?? email;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login berhasil. Selamat, $userEmail')),
          );
          // Navigasi ke halaman home dengan pass email
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(
              '/home',
              arguments: userEmail,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login gagal')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${resp.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesalahan: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Login',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(height: 36),

                const Text('email', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _pinkTextField(controller: _emailController, hint: 'username@gmail.com'),
                const SizedBox(height: 18),

                const Text('password', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _pinkTextField(controller: _passwordController, hint: '********', obscure: true),

                const SizedBox(height: 80),
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEE9E9E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/register'),
                    child: const Text('Belum punya akun? Daftar', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pinkTextField({required TextEditingController controller, required String hint, bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEE9E9E),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
