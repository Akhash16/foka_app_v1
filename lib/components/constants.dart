import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kTertiaryColor = Color(0xFF090f13);
const Color kCustomColor1 = Color(0xFFffffff);
const Color kPrimaryColor = Color(0xFF39d2c0);

TextStyle settingsHeadingTextStyle = GoogleFonts.montserrat(
  color: Colors.redAccent.shade100,
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

TextStyle settingsLeadingTextStyle = GoogleFonts.montserrat(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.w400,
);

TextStyle settingsTitleTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 20.0,
);

Icon settingsTrailingIcon = const Icon(
  Icons.arrow_drop_down_rounded,
  color: Colors.white,
  size: 40.0,
);

Divider settingsPageDivider = Divider(
  height: 20.0,
  thickness: 1.75,
  color: Colors.redAccent.shade100,
);

TextStyle homeScreenDialogTextStyle = GoogleFonts.getFont(
  'Lexend Deca',
  fontSize: 15,
);
