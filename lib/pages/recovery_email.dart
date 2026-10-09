import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_android/widgets/logo.dart';

class ForpassEmailScreen extends StatefulWidget {
  const ForpassEmailScreen({super.key});

  @override
  State<ForpassEmailScreen> createState() => _ForpassEmailScreenState();
}

class _ForpassEmailScreenState extends State<ForpassEmailScreen> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final TextEditingController _emailInputController = TextEditingController();

  static const Color _brandColor = Color(0xFF1A6556);
  static const Color _headerBgColor = Color(0xFFD9E5E1);
  static const Color _linkColor = Color(0xFF00B4D8);
  static const double _pagePadding = 8;

  // Ganti sesuai nama route halaman verifikasi di main.dart
  static const String _verificationRoute = '/changePass';

  @override
  void dispose() {
    _emailInputController.dispose();
    super.dispose();
  }

  void _submitEmailRecovery() {
    if (_emailFormKey.currentState?.validate() ?? false) {
      Navigator.pushNamed(
        context,
        _verificationRoute,
        arguments: _emailInputController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Theme(
      // Semua teks di halaman ini memakai font Kanit
      data: theme.copyWith(
        textTheme: theme.textTheme.apply(fontFamily: 'Kanit'),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(width),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _pagePadding),
                  child: _buildForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    final headerHeight = width * 0.66;

    return SizedBox(
      width: double.infinity,
      height: headerHeight,
      child: Stack(
        children: [
          // 1) Latar diagonal (satu-satunya yang di-clip)
          Positioned.fill(
            child: ClipPath(
              clipper: _EmailForgotClipper(),
              child: Container(color: _headerBgColor),
            ),
          ),

          // 2) Logo + judul di atas latar, tidak ikut terpotong
          Positioned(
            top: width * 0.34,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: width * 0.61,
                  child: const FittedBox(
                    fit: BoxFit.contain,
                    child: LogoWidget(),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'LUPA KATA SANDI',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    color: _brandColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.notifications_none, size: 26, color: Colors.black),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Periksa dan masukan alamat Email untuk mendapatkan kode verifikasi',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 13,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Input email: label di atas + garis bawah
        const Text(
          'Alamat Email',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 13,
            color: Color(0xFF555555),
          ),
        ),
        Form(
          key: _emailFormKey,
          child: TextFormField(
            controller: _emailInputController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            cursorColor: _brandColor,
            style: const TextStyle(fontFamily: 'Kanit', fontSize: 14),
            onFieldSubmitted: (_) => _submitEmailRecovery(),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 14),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF757575)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _brandColor, width: 1.5),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'Email tidak boleh kosong';
              if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)*\.[A-Za-z]{2,}$')
                  .hasMatch(email)) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 28),

        // Pindah ke pemulihan lewat nomor HP
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/forpassNoHp'),
          child: const Text(
            'Gunakan Nomor Hp',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 13,
              color: _linkColor,
            ),
          ),
        ),
        const SizedBox(height: 36),

        // Tombol kirim
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: _submitEmailRecovery,
            child: const Text(
              'KIRIM',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Potongan diagonal: kiri turun ±44% tinggi, kanan penuh (sesuai desain).
class _EmailForgotClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height * 0.44)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
