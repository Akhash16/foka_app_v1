import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/screens/location_tracker.dart';
import 'package:foka_app_v1/screens/smart_connect.dart';
import 'package:foka_app_v1/screens/ths_monitor.dart';
import 'package:foka_app_v1/screens/wifi_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progresso/progresso.dart';

import 'fluid_monitor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      InkWell(
        onTap: () => Navigator.pushNamed(context, THSScreen.id),
        child: DeviceCard(
          color: Colors.pink.shade600,
          title: "THS Monitor",
          description: "Tap here to more info",
          icon: const Icon(
            Icons.thermostat,
            color: Color(0xffffffff),
            size: 44,
          ),
        ),
      ),
      InkWell(
        onTap: () => Navigator.pushNamed(context, FluidMonitor.id),
        child: const DeviceCard(
          color: Color(0xff4b39ef),
          title: "Fluid Monitor",
          description: "Tap here to monitor fluid levels",
          icon: Icon(
            Icons.water,
            color: Color(0xffffffff),
            size: 44,
          ),
        ),
      ),
      InkWell(
        onTap: () => Navigator.pushNamed(context, SmartConnet.id),
        child: const DeviceCard(
          // color: Color(0xff4b39ef),
          color: Colors.pink,
          title: "Smart Connect",
          description: "Tap here to more details",
          icon: Icon(
            Icons.water,
            color: Color(0xffffffff),
            size: 44,
          ),
        ),
      ),
      InkWell(
        onTap: () => Navigator.pushNamed(context, LocationScreen.id),
        child: const DeviceCard(
          color: Color(0xff8b0f32),
          title: "Location Tracker",
          description: "Tap here to locate your boat",
          icon: Icon(
            Icons.location_on,
            color: Color(0xffffffff),
            size: 44,
          ),
        ),
      ),
      InkWell(
        onTap: () => print('security monitor'),
        child: DeviceCard(
          color: Colors.orange.shade600,
          title: "Security Monitor",
          description: "Tap here to monitor your boat",
          icon: const Icon(
            Icons.security,
            color: Color(0xffffffff),
            size: 44,
          ),
        ),
      ),
    ];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
        onPressed: () {
          Navigator.pushNamed(context, WifiScreen.id);
        },
      ),
      backgroundColor: const Color(0xff090f13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Boat",
                  style: GoogleFonts.lexendDeca(
                      color: const Color(0xff95a1ac),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "Boat Name",
                  style: GoogleFonts.lexendDeca(
                      color: const Color(0xffffffff),
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Image.network(
                    "https://cdn.discordapp.com/attachments/867367813047779338/921427885888249876/117-1176532_yacht-png-transparent-yacht-side-view-png-png-removebg-preview.png",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 13, 8, 12),
                  child: Progresso(
                    progressColor: const Color(0xFF39d2c0),
                    backgroundStrokeWidth: 16,
                    progressStrokeWidth: 13,
                    progress: 0.7,
                    progressStrokeCap: StrokeCap.round,
                    backgroundStrokeCap: StrokeCap.round,
                  ),
                  // child: Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Stack(
                  //       children: [
                  //         Container(
                  //           width: MediaQuery.of(context).size.width * 0.9,
                  //           height: 17,
                  //           decoration: BoxDecoration(
                  //             color: const Color(0xffdbe2e7),
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding:
                  //               const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                  //           child: Container(
                  //             width: MediaQuery.of(context).size.width * 0.4,
                  //             height: 13,
                  //             decoration: BoxDecoration(
                  //               color: const Color(0xff39d2c0),
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Charge",
                            style: GoogleFonts.lexendDeca(
                                color: const Color(0xff95a1ac),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "70%",
                            style: GoogleFonts.lexendDeca(
                                color: const Color(0xffffffff),
                                fontSize: 28,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Status",
                            style: GoogleFonts.lexendDeca(
                                color: const Color(0xff95a1ac),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Good",
                            style: GoogleFonts.lexendDeca(
                                color: const Color(0xFF39d2c0),
                                fontSize: 28,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                Center(
                  child: RoundedButton(
                    title: "Start Diagnostic",
                    color: const Color(0xFF107896),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        'Fluid Monitor',
                                        style: GoogleFonts.getFont(
                                          'Lexend Deca',
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'THS Monitor',
                                        style: GoogleFonts.getFont(
                                          'Lexend Deca',
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Security Monitor',
                                        style: GoogleFonts.getFont(
                                          'Lexend Deca',
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Smart Connect',
                                        style: GoogleFonts.getFont(
                                          'Lexend Deca',
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Location Tracker',
                                        style: GoogleFonts.getFont(
                                          'Lexend Deca',
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    // CircularProgressIndicator(
                                    //   value: controller.value,
                                    //   semanticsLabel: 'Linear progress indicator',
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                // Center(
                //   child: CircularProgressIndicator(
                //     backgroundColor: Colors.white,
                //     // color: Colors.white,
                //     value: controller.value,
                //     semanticsLabel: 'Linear progress indicator',
                //   ),
                // ),
                // SizedBox(
                //   height: 20.0,
                // ),
                CarouselSlider(
                  items: items,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.23,
                    viewportFraction: 0.63,
                    enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  const DeviceCard(
      {Key? key,
      required this.color,
      required this.title,
      required this.description,
      required this.icon})
      : super(key: key);
  final Icon icon;
  final String title;
  final String description;
  final Color color;
  // final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x37000000),
            offset: Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      width: 220,
      height: 220,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: icon,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: AutoSizeText(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(
                  color: const Color(0xffffffff),
                  textStyle: TextStyle(fontSize: 18)),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Lexend Deca',
                color: const Color(0xB3FFFFFF),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
