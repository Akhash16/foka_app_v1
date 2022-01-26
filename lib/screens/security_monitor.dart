import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/snaps_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);
  static const id = "security_monitor";

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  String alertStatus = "OFF";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090f13),
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context, HomeScreen.id);
          },
        ),
        title: const Text(
          'Security Monitor',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, THSSettingsPage.id);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Column(
             
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 35),
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xff277D8E)
                            // color: alertStatus == "OFF"
                            //     ? Colors.red
                            //     : Colors.greenAccent.shade700,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.shade800.withOpacity(0.7),
                            //     spreadRadius: 5,
                            //     blurRadius: 7,
                            //     offset:
                            //         const Offset(0, 4), // changes position of shadow
                            //   ),
                            // ],
                            ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            alertStatus == "OFF"
                                ? const Icon(
                                    Icons.lock_open_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  )
                                : const Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                              child: Text(
                                alertStatus,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          
                          setState(() {
                            if (alertStatus == "OFF") {
                              alertStatus = "ON";
                            } else {
                              alertStatus = "OFF";
                            }
                          });
                        },
                        child: alertStatus == "ON"
                            ? const Icon(
                                Icons.lock_open_rounded,
                                color: Colors.white,
                                size: 40,
                              )
                            : const Icon(
                                Icons.lock_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xff84BEC9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade700.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.24,
                      height: MediaQuery.of(context).size.width * 0.24,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(alertStatus == "OFF" ? "ON" : "OFF",
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedButton(
                title: "Snapshots",
                color: const Color(0xff277D8E),
                onPressed: () {
                  Navigator.pushNamed(context, SnapsScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
