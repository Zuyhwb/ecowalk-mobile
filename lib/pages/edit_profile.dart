import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  static const Color _brandColor = Color(0xFF1A6556);
  static const Color _iconGrey = Color(0xFF757575);
  static const String _photoAsset = 'lib/assets/images/kucing.jpg';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _changePhoto() {
    // TODO: pilih foto dari galeri (mis. dengan paket image_picker)
    _showMessage('Ubah foto belum tersedia');
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // TODO: simpan nama baru (mis. ke shared_preferences)
    _showMessage('Profil berhasil disimpan');
    Navigator.pop(context, _nameController.text.trim());
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topInset = MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    final avatarSize = width * 0.32;

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
          body: Column(
            children: [
              // Area status bar putih
              SizedBox(height: topInset),

              // Bar hijau
              _buildTopBar(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      _buildAvatar(avatarSize),
                      const SizedBox(height: 44),
                      _buildNameField(),
                      const SizedBox(height: 64),
                      _buildSaveButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: _brandColor,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 2),
          const Text(
            'Edit Profil',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipOval(
              child: Image.asset(
                _photoAsset,
                fit: BoxFit.cover,
                // Jika foto tidak ditemukan, tampilkan ikon pengganti
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFE0E0E0),
                  child: const Icon(
                    Icons.person,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Badge pensil di kanan bawah
          Positioned(
            right: -2,
            bottom: 2,
            child: GestureDetector(
              onTap: _changePhoto,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: _brandColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _nameController,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.words,
        cursorColor: _brandColor,
        style: const TextStyle(fontFamily: 'Kanit', fontSize: 13),
        onFieldSubmitted: (_) => _save(),
        decoration: const InputDecoration(
          hintText: 'Nama Pengguna',
          hintStyle: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 13,
            fontStyle: FontStyle.italic,
            color: Color(0xFF666666),
          ),
          prefixIcon: Icon(Icons.person, size: 22, color: _iconGrey),
          prefixIconConstraints: BoxConstraints(minWidth: 36),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
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
          final name = value?.trim() ?? '';
          if (name.isEmpty) return 'Nama tidak boleh kosong';
          if (name.length < 3) return 'Nama minimal 3 karakter';
          return null;
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: _save,
        child: const Text(
          'SIMPAN',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
