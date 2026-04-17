import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _loading = false;

  // Terhubung ke backend di htdocs Apache/XAMPP
  // Jika folder backend berbeda, sesuaikan path di sini
  final String _registerUrl = 'http://localhost/backend/register.php';

  Future<void> _submit() async {
    final name = _nameController.text.trim();
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
      final resp = await http.post(Uri.parse(_registerUrl), body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
      }).timeout(const Duration(seconds: 10));

      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pendaftaran berhasil. Silakan login.')),
          );
          // kembali ke halaman login
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Pendaftaran gagal')),
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
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('name', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _pinkTextField(controller: _nameController, hint: 'Nama lengkap'),
                const SizedBox(height: 18),

                const Text('email', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _pinkTextField(controller: _emailController, hint: 'username@gmail.com'),
                const SizedBox(height: 18),

                const Text('password', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 18),

                const Text('no. telepon', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _pinkTextField(controller: _phoneController, hint: '0812-3456-7890'),
                const SizedBox(height: 18),

                const Text('alamat', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _pinkTextField(controller: _addressController, hint: 'Jl. Contoh No. 123'),
                const SizedBox(height: 8),
                _pinkTextField(controller: _passwordController, hint: '********', obscure: true),

                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: 160,
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
                          : const Text('Register', style: TextStyle(color: Colors.black)),
                    ),
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
