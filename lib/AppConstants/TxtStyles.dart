import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TxtStyles {
  static TextStyle customStyle({
    Color color = inputColor,
    double fontSize = 15.0,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    try {
      return GoogleFonts.nunitoSans(
        textStyle: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: 0.2,
          height: 1.4,
        ),
      );
    } catch (e) {
      return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );
    }
  }
}


const Color scaffoldBg = Color(0xFFF7FFFF);
const Color whiteColor = Colors.white;
const Color gradient1 = Color(0xFF1A365D);
const Color gradient2 = Color(0xFF007C91);
const Color greyColor = Color(0xFF717171);
const Color greyColor2 = Color(0xFF939393);
const Color inputColor = Color(0xFF0D121C);
const Color errorColor = Color(0xFFEB6A6A);