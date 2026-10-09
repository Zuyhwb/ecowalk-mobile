import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ECOWA',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A6556),
          ),
        ),

        SvgPicture.asset('lib/images/Vector(1).svg', width: 45, height: 45),

        Text(
          'K',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A6556),
          ),
        ),
      ],
    );
  }
}
