// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/boat_add_data.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class AddBoatScreen extends StatelessWidget {
  const AddBoatScreen({Key? key}) : super(key: key);

  static const String id = 'add_boat_screen';

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xff1A1E20).withOpacity(1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add Boat',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: TextField(
              controller: textController,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                hintText: 'Enter Hub ID',
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.white24,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          ConfirmationSlider(
            onConfirmation: () {
              Navigator.popAndPushNamed(context, BoatsPage.id);
            },
            height: 60,
            width: 260,
            sliderButtonContent: const Icon(Icons.chevron_right, color: Colors.white, size: 30),
            backgroundColor: Colors.white12,
            textStyle: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
