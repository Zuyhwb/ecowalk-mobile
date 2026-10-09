import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_android/widgets/logo.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _hideNewPass = true;
  bool _hideConfirmPass = true;

  static const Color _brandColor = Color(0xFF1A6556);
  static const Color _headerBgColor = Color(0xFFD9E5E1);
  static const Color _iconGrey = Color(0xFF757575);
  static const double _pagePadding = 16;

  // Ganti sesuai nama route halaman login di main.dart
  static const String _loginRoute = '/login';

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _submitNewPassword() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // TODO: simpan kata sandi baru (mis. ke penyimpanan lokal) sebelum pindah
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Kata sandi berhasil diubah')),
      );

    Navigator.pushNamedAndRemoveUntil(context, _loginRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Theme(
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
                const SizedBox(height: 36),
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
          // Latar diagonal (satu-satunya yang di-clip)
          Positioned.fill(
            child: ClipPath(
              clipper: _ChangePassClipper(),
              child: Container(color: _headerBgColor),
            ),
          ),

          // Logo + judul di atas latar
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Masukan Kata Sandi Baru',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),

          // Kata sandi baru
          _buildPasswordField(
            controller: _newPassController,
            hint: 'Kata Sandi Baru',
            obscure: _hideNewPass,
            onToggle: () => setState(() => _hideNewPass = !_hideNewPass),
            action: TextInputAction.next,
            validator: (value) {
              final pass = value ?? '';
              if (pass.isEmpty) return 'Kata sandi tidak boleh kosong';
              if (pass.length < 8) return 'Kata sandi minimal 8 karakter';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Konfirmasi kata sandi
          _buildPasswordField(
            controller: _confirmPassController,
            hint: 'Konfirmasi Kata Sandi',
            obscure: _hideConfirmPass,
            onToggle: () =>
                setState(() => _hideConfirmPass = !_hideConfirmPass),
            action: TextInputAction.done,
            onSubmitted: (_) => _submitNewPassword(),
            validator: (value) {
              if ((value ?? '').isEmpty) return 'Konfirmasi kata sandi kosong';
              if (value != _newPassController.text) {
                return 'Kata sandi tidak sama';
              }
              return null;
            },
          ),
          const SizedBox(height: 40),

          // Tombol ubah kata sandi
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
              onPressed: _submitNewPassword,
              child: const Text(
                'UBAH KATA SANDI',
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
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
    TextInputAction action = TextInputAction.next,
    void Function(String)? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      textInputAction: action,
      onFieldSubmitted: onSubmitted,
      cursorColor: _brandColor,
      style: const TextStyle(fontFamily: 'Kanit', fontSize: 13),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Kanit',
          fontSize: 13,
          fontStyle: FontStyle.italic,
          color: Color(0xFF666666),
        ),
        prefixIcon: const Icon(Icons.lock, size: 20, color: _iconGrey),
        prefixIconConstraints: const BoxConstraints(minWidth: 34),
        suffixIcon: IconButton(
          splashRadius: 18,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: _iconGrey,
          ),
          onPressed: onToggle,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _iconGrey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _brandColor, width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

/// Potongan diagonal: kiri turun ±44% tinggi, kanan penuh (sesuai desain).
class _ChangePassClipper extends CustomClipper<Path> {
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
