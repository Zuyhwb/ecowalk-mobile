import 'package:flutter/material.dart';
import 'package:test_android/pages/change_password.dart';
import 'package:test_android/pages/edit_profile.dart';
import 'package:test_android/pages/login_page.dart';
import 'package:test_android/pages/profile_page.dart';
import 'package:test_android/pages/recovery_Nohp.dart';
import 'package:test_android/pages/recovery_email.dart';
import 'package:test_android/pages/register_page.dart';
import 'package:test_android/pages/verification_page.dart';

import 'pages/splash_page.dart';

void main() {
  runApp(const EcoWalkApp());
}

class EcoWalkApp extends StatelessWidget {
  const EcoWalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECOWALK',

      initialRoute: "/splash",

      // Semua halaman aplikasi
      routes: {
        "/splash": (context) => const SplashPage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        '/verification': (context) => const VerificationPage(),
        "/verificationWithNoHP": (context) =>
            const VerificationPage(byPhone: true),
        "/forpassEmail": (context) => ForpassEmailScreen(),
        "/forpassNoHp": (context) => ForpassPhoneScreen(),
        "/changePass": (context) => const ChangePassScreen(),
        "/profile": (context) => ProfileScreen(),
        "/editProfile": (context) => const EditProfileScreen(),
      },
    );
  }
}
