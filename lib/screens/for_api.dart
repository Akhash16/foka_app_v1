import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/splash_screen.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:google_fonts/google_fonts.dart';

class ForAPI extends StatefulWidget {
  const ForAPI({Key? key}) : super(key: key);

  static const String id = 'for_api';

  @override
  State<ForAPI> createState() => _ForAPIState();
}

class _ForAPIState extends State<ForAPI> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              hintText: 'Enter API',
              hintStyle: GoogleFonts.montserrat(
                color: Colors.white24,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          RoundedButton(
              title: 'API',
              color: Colors.lightBlueAccent,
              onPressed: () {
                ApiCalls.updateApi(controller.text.trim());
                Navigator.popAndPushNamed(context, SplashScreen.id);
              }),
          const SizedBox(height: 20),
          RoundedButton(
              title: 'Choose ADR API',
              color: Colors.lightBlueAccent,
              onPressed: () {
                // ApiCalls.updateApi('http://164.52.212.96:3000');
                Navigator.popAndPushNamed(context, SplashScreen.id);
              })
        ],
      ),
    );
  }
}
