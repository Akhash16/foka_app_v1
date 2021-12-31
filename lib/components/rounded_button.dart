import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({required this.title, required this.color, required this.onPressed, this.width = 230.0, this.fontSize = 18.0});

  final double fontSize;
  final double width;
  final String title;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 3.0,
        color: color,
        borderRadius: BorderRadius.circular(50.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: width,
          height: 50.0,
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            // style: GoogleFonts.lexendDeca(
            //   textStyle: const TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w700,
            //     color: Colors.white,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
