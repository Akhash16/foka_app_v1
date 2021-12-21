import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/components/error_alert.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  static const String id = "forgot_password";

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailAddressController = TextEditingController();
  RegExp isEmailValid = RegExp(r'[A-Za-z0-9.-_]+@[A-Za-z0-9.-_]+\.[A-Za-z]{2,3}');
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1A1E20),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        title: const Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
          child: Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xff1A1E20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 38, 18, 18),
              child: TextFormField(
                controller: emailAddressController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: GoogleFonts.lexendDeca(
                    textStyle: const TextStyle(
                      color: Color(0xFF95A1AC),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  hintText: 'Enter your email here...',
                  hintStyle: GoogleFonts.lexendDeca(
                    textStyle: const TextStyle(
                      color: Color(0xFF95A1AC),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff111417),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF111417),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: const Color(0xff111417),
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 20, 0, 24),
                ),
                style: GoogleFonts.lexendDeca(
                  textStyle: const TextStyle(
                    color: Color(0xFF2B343A),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: const Text(
                'Enter a valid email Id',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                'We rend you an email with a link to reset your password, please enter the email associated with your account above.',
                style: GoogleFonts.lexendDeca(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            RoundedButton(
                title: "Send Reset Link",
                color: kPrimaryColor,
                onPressed: () {
                  String email = emailAddressController.text.trim();
                  if (isEmailValid.hasMatch(email)) {
                    setState(() {
                      isVisible = false;
                    });
                    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    Navigator.popAndPushNamed(context, LoginScreen.id);
                  } else {
                    setState(() {
                      isVisible = true;
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
