import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MakeSure extends StatefulWidget {
  const MakeSure({Key? key}) : super(key: key);
  static const String id = "make_sure";

  @override
  _MakeSureState createState() => _MakeSureState();
}

class _MakeSureState extends State<MakeSure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1A1E20),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Lottie.asset(
                  "assets/message.json",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Make sure you are physically present on boat(s)",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontStyle: FontStyle.normal,
                    fontSize: 25,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ));
  }
}
