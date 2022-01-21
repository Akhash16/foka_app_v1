import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/qr_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ConnectDevice extends StatelessWidget {
  const ConnectDevice({Key? key}) : super(key: key);
  static const String id = "connect_device";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushNamed(context, QrScreen.id);
        },
        child: const Icon(
          Icons.navigate_next,
          size: 40,
        ),
      ),
      backgroundColor: const Color(0xff090f13),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Lottie.asset(
                "assets/connected.json",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Connect to your device wifi now(eg. Fokatech ultrasonic fkbxxx)",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500,),
            ),
          )
        ],
      ),
    );
  }
}
