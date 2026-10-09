import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _primaryThemeColor = Color(0xFF1A6556);
  static const Color _dividerColor = Color(0xFFD0D0D0);

  static const String _displayName = 'Squarepents';
  static const String _email = 'kayimail@gmail.com';
  static const String _photoAsset = 'lib/images/spongebob.jpg';

  // Ganti sesuai nama route di main.dart
  static const String _homeRoute = '/home';
  static const String _loginRoute = '/login';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.apply(fontFamily: 'Kanit'),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          // Tanpa SafeArea: header hijau harus sampai ke status bar
          body: Column(
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 8),
              const Text(
                _displayName,
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              _buildEmailPill(context),
              const SizedBox(height: 22),
              Expanded(child: _buildMenuList(context)),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(context),
        ),
      ),
    );
  }

  // ---------- Header ----------

  Widget _buildProfileHeader(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bandHeight = width * 0.40; // sudah termasuk area status bar
    final avatarSize = width * 0.33;

    return SizedBox(
      height: bandHeight + avatarSize / 2,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: bandHeight,
            color: _primaryThemeColor,
          ),
          Positioned(
            top: bandHeight - avatarSize / 2,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  _photoAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  // Jika foto tidak ditemukan, tampilkan ikon pengganti
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE0E0E0),
                    child: const Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailPill(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.50,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _primaryThemeColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        _email,
        style: TextStyle(
          fontFamily: 'Kanit',
          fontSize: 11,
          color: Colors.white,
        ),
      ),
    );
  }

  // ---------- Menu ----------

  Widget _buildMenuList(BuildContext context) {
    final menuItems = <_ProfileItemData>[
      _ProfileItemData(
        icon: Icons.settings_outlined,
        title: 'Pengaturan',
        onTap: () => _showSoon(context, 'Pengaturan'),
      ),
      _ProfileItemData(
        icon: Icons.edit_outlined,
        title: 'Edit Profil',
        onTap: () => Navigator.pushNamed(context, '/editprofile'),
      ),
      _ProfileItemData(
        icon: Icons.lock_outline,
        title: 'Kebijakan Privasi',
        onTap: () => _showSoon(context, 'Kebijakan Privasi'),
      ),
      _ProfileItemData(
        icon: Icons.info_outline,
        title: 'Tentang Kami',
        onTap: () => _showSoon(context, 'Tentang Kami'),
      ),
      _ProfileItemData(
        icon: Icons.fact_check_outlined,
        title: 'Ketentuan Layanan',
        onTap: () => _showSoon(context, 'Ketentuan Layanan'),
      ),
      _ProfileItemData(
        icon: Icons.logout,
        title: 'Keluar',
        showDivider: false,
        onTap: () => _confirmLogout(context),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: menuItems.length,
      itemBuilder: (context, index) => _buildMenuTile(menuItems[index]),
    );
  }

  Widget _buildMenuTile(_ProfileItemData item) {
    return Column(
      children: [
        InkWell(
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              children: [
                Icon(item.icon, size: 24, color: Colors.black),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 30, color: Colors.black),
              ],
            ),
          ),
        ),
        if (item.showDivider)
          const Divider(height: 1, thickness: 1, color: _dividerColor),
      ],
    );
  }

  void _showSoon(BuildContext context, String title) {
    // TODO: ganti dengan Navigator.pushNamed(...) saat halamannya sudah ada
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$title belum tersedia')));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: _primaryThemeColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, _loginRoute, (_) => false);
    }
  }

  // ---------- Bottom navigation ----------

  Widget _buildBottomNav(BuildContext context) {
    const double barHeight = 52;
    const double circleSize = 66;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: barHeight + circleSize / 2 + bottomInset,
      child: Stack(
        children: [
          // Latar hijau
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight + bottomInset,
            child: Container(color: _primaryThemeColor),
          ),

          // Empat slot sama lebar
          Positioned.fill(
            bottom: bottomInset,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _navItem(
                  const Icon(
                    Icons.home_outlined,
                    size: 32,
                    color: Colors.white,
                  ),
                  () => Navigator.pushReplacementNamed(context, _homeRoute),
                  barHeight,
                ),
                _navItem(
                  const Icon(
                    Icons.verified_user,
                    size: 28,
                    color: Colors.white,
                  ),
                  () {
                    // TODO: halaman kedua
                  },
                  barHeight,
                ),
                _navItem(const _ChatHeartIcon(), () {
                  // TODO: halaman ketiga
                }, barHeight),

                // Tombol AKUN (aktif)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: circleSize,
                        height: circleSize,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _primaryThemeColor,
                        ),
                        child: Container(
                          width: circleSize - 16,
                          height: circleSize - 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 34,
                            color: _primaryThemeColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'AKUN',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(Widget icon, VoidCallback onTap, double height) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: InkResponse(
            onTap: onTap,
            radius: 28,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}

/// Ikon bubble chat putih dengan hati hijau di tengah.
class _ChatHeartIcon extends StatelessWidget {
  const _ChatHeartIcon();

  static const Color _heartColor = Color(0xFF1A6556);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        Icon(Icons.chat_bubble, color: Colors.white, size: 30),
        Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Icon(Icons.favorite, color: _heartColor, size: 13),
        ),
      ],
    );
  }
}

class _ProfileItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const _ProfileItemData({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });
}
