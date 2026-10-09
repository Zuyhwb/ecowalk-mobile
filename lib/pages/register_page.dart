import 'package:flutter/material.dart';
import 'package:test_android/widgets/logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isAgreed = false;
  bool _obscurePass = true;
  bool _obscureConf = true;

  static const Color _primary = Color(0xFF1A6556);

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "BUAT AKUN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _primary,
                    ),
                  ),
                  const Center(child: LogoWidget()),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration(
                      label: "Nama Pengguna",
                      icon: Icons.person,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama pengguna tidak boleh kosong';
                      }
                      if (value.trim().length < 3) {
                        return 'Nama pengguna minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration(label: "Email", icon: Icons.email),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      final emailRegex = RegExp(
                        r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration(
                      label: "Nomor Hp",
                      icon: Icons.phone,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nomor HP tidak boleh kosong';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                        return 'Nomor HP hanya boleh berisi angka';
                      }
                      if (value.trim().length < 10) {
                        return 'Nomor HP minimal 10 digit';
                      }
                      if (value.trim().length > 15) {
                        return 'Nomor HP maksimal 15 digit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePass,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration(
                      label: "Kata Sandi",
                      icon: Icons.lock,
                      suffix: IconButton(
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      if (value.length < 6) {
                        return 'Kata sandi minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConf,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _decoration(
                      label: "Konfirmasi Kata Sandi",
                      icon: Icons.lock,
                      suffix: IconButton(
                        onPressed: () =>
                            setState(() => _obscureConf = !_obscureConf),
                        icon: Icon(
                          _obscureConf
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi kata sandi tidak boleh kosong';
                      }
                      if (value != _passwordController.text) {
                        return 'Konfirmasi kata sandi tidak cocok';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CheckboxListTile(
                    value: _isAgreed,
                    onChanged: (value) {
                      setState(() => _isAgreed = value ?? false);
                    },
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text.rich(
                      TextSpan(
                        text: 'Saya telah menyetujui ',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        children: const [
                          TextSpan(
                            text: 'persyaratan dan privasi pengguna',
                            style: TextStyle(color: Colors.cyan),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (!_isAgreed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Silakan setujui persyaratan dan privasi pengguna terlebih dahulu',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          Navigator.pushNamed(
                            context,
                            "/verificationWithNoHP",
                            arguments: _phoneController.text.trim(),
                          );
                        }
                      },
                      child: const Text(
                        'BUAT AKUN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(fontSize: 11),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(fontSize: 11, color: Colors.cyan),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
