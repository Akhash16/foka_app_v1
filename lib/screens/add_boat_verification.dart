import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:animate_do/animate_do.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/screens/splash_screen.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddBoatVerification extends StatefulWidget {
  // const AddBoatVerification({Key? key}) : super(key: key);
  AddBoatVerification({this.hubId, this.boatName});

  final hubId;
  final boatName;

  static const String id = 'add_boat_verification';

  @override
  _AddBoatVerificationState createState() => _AddBoatVerificationState();
}

class _AddBoatVerificationState extends State<AddBoatVerification> {
  bool showSpinner = false;

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1A1E20),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  'Boat Name',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 700),
                child: Padding(
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
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      hintText: 'Enter Boat Name',
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.white24,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 900),
                child: ConfirmationSlider(
                  onConfirmation: () {
                    // if (textController.text != '') {
                    // ApiCalls().addBoatsApi(widget.hubId, widget.boatName, textController.text);
                    // Navigator.popAndPushNamed(context, SplashScreen.id);
                    // }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
