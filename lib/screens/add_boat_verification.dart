import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:animate_do/animate_do.dart';
import 'package:foka_app_v1/screens/add_boat_screen.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddBoatVerification extends StatefulWidget {
  const AddBoatVerification({Key? key}) : super(key: key);

  static const String id = 'add_boat_verification';

  @override
  _AddBoatVerificationState createState() => _AddBoatVerificationState();
}

class _AddBoatVerificationState extends State<AddBoatVerification> {
  bool _onEditing = true;
  late String _code;
  bool showSpinner = false;

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
                  'Enter OTP',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              FadeInDown(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 700),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VerificationCode(
                    length: 4,
                    underlineWidth: 3,
                    itemSize: 70.0,
                    textStyle: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                    underlineColor: Colors.lightBlueAccent,
                    keyboardType: TextInputType.number,
                    underlineUnfocusedColor: Colors.white,
                    onCompleted: (value) {
                      setState(() {
                        _code = value;
                      });
                    },
                    onEditing: (value) {
                      setState(() {
                        _onEditing = value;
                      });
                    },
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              // Text(
              //   _onEditing ? 'Entering Code' : 'Code is ' + _code,
              //   style: GoogleFonts.montserrat(
              //     color: Colors.white,
              //     fontSize: 20,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              const SizedBox(
                height: 20.0,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 900),
                child: ConfirmationSlider(
                  onConfirmation: () {
                    _onEditing ? null : Navigator.popAndPushNamed(context, BoatsPage.id);
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
