import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/components/error_alert.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/forgot_password.dart';
import 'package:foka_app_v1/screens/onboarding.dart';
import 'package:foka_app_v1/screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RegExp emailRegex = RegExp(r'[A-Za-z0-9.-_]+@[A-Za-z0-9.-_]+\.[A-Za-z]{2,3}');

  bool isEmailInvalid = false;
  bool isPasswordMissing = false;

  bool passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              "https://images.unsplash.com/photo-1514563229751-01c68026cb49?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
              // height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding:   EdgeInsets.fromLTRB(28.0,MediaQuery.of(context).size.height * 0.1,28.0,28.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Padding(
                  //   padding: EdgeInsets.fromLTRB(8, 50, 0, 40),
                  //   child: FlutterLogo(
                  //     size: 50,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Image.network(
                        'https://cdn.discordapp.com/attachments/841898285118652461/926791595108466748/foka_logo-removebg-preview_1.png',
                        color: Colors.white,
                        height: 100,
                        width: 200,
                      ),
                    ),
                  ),
                  Text(
                    "Welcome!",
                    style: GoogleFonts.lexendDeca(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    "Features for Future",
                    style: GoogleFonts.lexendDeca(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 28, 0, 4),
                    child: TextFormField(
                      controller: emailAddressController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: GoogleFonts.lexendDeca(
                          textStyle: const TextStyle(
                            color: Color(0xFF95A1AC),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
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
                            color: Color(0xFFDBE2E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFDBE2E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
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
                    visible: isEmailInvalid,
                    child: const Text(
                      'Enter a valid Email Id',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.lexendDeca(
                          textStyle: const TextStyle(
                            color: Color(0xFF95A1AC),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
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
                            color: Color(0xFFDBE2E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFDBE2E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 20, 24, 24),
                        suffixIcon: InkWell(
                          onTap: () => setState(
                            () => passwordVisibility = !passwordVisibility,
                          ),
                          child: Icon(
                            passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF95A1AC),
                            size: 22,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF2B343A),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isPasswordMissing,
                    child: const Text(
                      'Enter Password',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterScreen.id);
                        },
                        child: Text(
                          "Don't have an account?",
                          style: GoogleFonts.lexendDeca(
                            textStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      RoundedButton(
                        title: "Login",
                        color: kPrimaryColor,
                        width: 130.0,
                        onPressed: () {
                          String email = emailAddressController.text.trim();
                          String password = passwordController.text.trim();

                          try {
                            if (emailRegex.hasMatch(email)) {
                              setState(() {
                                isEmailInvalid = false;
                              });
                              if (password != '') {
                                setState(() {
                                  isPasswordMissing = false;
                                });
                                FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                                Navigator.popAndPushNamed(context, Onboarding.id);
                              } else {
                                setState(() {
                                  isPasswordMissing = true;
                                });
                              }
                            } else {
                              setState(() {
                                isEmailInvalid = true;
                              });
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 28, 8, 18),
                    child: InkWell(
                      onTap: () => Navigator.popAndPushNamed(context, ForgotPassword.id),
                      child: Center(
                        child: Text(
                          "forgot Password?",
                          style: GoogleFonts.lexendDeca(
                            textStyle: const TextStyle(color: Color(0xf0ffffff), fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Use a Social Platform to Login",
                        style: GoogleFonts.lexendDeca(
                          textStyle: const TextStyle(color: Color(0xb2ffffff), fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          child: Image.network("https://cdn.freebiesupply.com/logos/large/2x/google-g-2015-logo-png-transparent.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Image.asset("assets/apple.png", height: 30),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.phone,
                              color: Colors.deepPurple,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
