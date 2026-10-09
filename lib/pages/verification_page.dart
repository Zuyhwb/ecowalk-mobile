import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_android/widgets/logo.dart';

class VerificationPage extends StatefulWidget {
  /// false = verifikasi lewat email, true = lewat nomor HP
  final bool byPhone;

  const VerificationPage({super.key, this.byPhone = false});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  static const Color _primary = Color(0xFF1A6556);
  static const Color _headerBg = Color(0xFFD9E6E3);
  static const int _codeLength = 4;
  static const int _resendSeconds = 60;
  static const double _boxGap = 16;
  static const double _boxScale = 0.88; // kecilkan: 0.80 | besarkan: 0.95

  final List<TextEditingController> _controllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _codeLength,
    (_) => FocusNode(),
  );

  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = _resendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) t.cancel();
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  String _formatPhone(String p) {
    final n = p.trim();
    if (n.startsWith('+')) return n;
    if (n.startsWith('0')) return '+62${n.substring(1)}';
    if (n.startsWith('62')) return '+$n';
    return '+62$n';
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (value.isNotEmpty && index == _codeLength - 1) {
      FocusScope.of(context).unfocus();
    }
  }

  void _onSubmit() {
    if (_code.length < _codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan 4 digit kode verifikasi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: kirim _code ke backend untuk diverifikasi
    Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
  }

  void _onResend() {
    if (_secondsLeft > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tunggu $_secondsLeft detik lagi')),
      );
      return;
    }
    // TODO: panggil API kirim ulang kode
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    setState(_startTimer);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode verifikasi dikirim ulang')),
    );
  }

  /// Satu kotak kode berbentuk persegi (size x size)
  Widget _codeBox(int index, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        expands: true,
        maxLines: null,
        minLines: null,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (v) => _onChanged(v, index),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _codeRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullSize =
            (constraints.maxWidth - _boxGap * (_codeLength - 1)) / _codeLength;
        final size = fullSize * _boxScale;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [for (int i = 0; i < _codeLength; i++) _codeBox(i, size)],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    // Data dari register: Map {'phone':..., 'email':...} atau String nomor HP
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map data = args is Map
        ? args
        : (args is String ? {'phone': args} : {});

    final rawPhone = (data['phone'] as String?) ?? '';
    final phone = rawPhone.isEmpty ? '+620000000000' : _formatPhone(rawPhone);
    final email = (data['email'] as String?) ?? 'contohsample@gmail.com';
    final target = widget.byPhone ? phone : email;

    // Header mengikuti lebar layar (proporsi dari desain 360 px)
    final headerHeight = w * 0.65;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Header diagonal + logo =====
            SizedBox(
              height: headerHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipPath(
                      clipper: _DiagonalClipper(),
                      child: Container(color: _headerBg),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: w * 0.37,
                    child: const Center(child: LogoWidget()),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),

                  // ===== Judul =====
                  Row(
                    children: const [
                      Icon(Icons.check, size: 18),
                      SizedBox(width: 12),
                      Text(
                        'VERIFIKASI',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ===== Keterangan =====
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/images/phone.svg',
                        width: 26,
                        height: 33,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'Periksa dan ketik kode verifikasi yang telah dikirimkan ke ',
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: target,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ===== Kotak kode =====
                  _codeRow(),
                  const SizedBox(height: 28),

                  // ===== Ganti metode verifikasi =====
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        widget.byPhone
                            ? '/verification'
                            : '/verificationWithNoHP',
                        arguments: data,
                      );
                    },
                    child: Text(
                      widget.byPhone
                          ? 'Verifikasi menggunakan Email'
                          : 'Verifikasi menggunakan No. Hp',
                      style: const TextStyle(fontSize: 11, color: Colors.cyan),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ===== Tombol Kirim =====
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: _onSubmit,
                      child: const Text(
                        'KIRIM',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== Kirim ulang =====
                  Center(
                    child: GestureDetector(
                      onTap: _onResend,
                      child: const Text(
                        'Kirim Ulang Kode',
                        style: TextStyle(fontSize: 11, color: _primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diagonal seperti desain: kiri turun ±44%, kanan sampai dasar header
class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height * 0.44)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
