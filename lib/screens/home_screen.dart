import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> items = [
    const DeviceCard(
      color: Color(0xff4b39ef),
      title: "Location tracker",
      description: "Tap here to locate your boat",
      icon: Icon(
        Icons.location_on,
        color: Color(0xffffffff),
        size: 44,
      ),
    ),
    const DeviceCard(
      color: Color(0xff39d2c0),
      title: "Security Monitor",
      description: "Tap here to monitor your boat",
      icon: Icon(
        Icons.security,
        color: Color(0xffffffff),
        size: 44,
      ),
    ),
    const DeviceCard(
      color: Color(0xff4b39ef),
      title: "THS Monitor",
      description: "Tap here to more info",
      icon: Icon(
        Icons.thermostat,
        color: Color(0xffffffff),
        size: 44,
      ),
    ),
    const DeviceCard(
      color: Color(0xff39d2c0),
      title: "Fluid Monitor",
      description: "Tap here to monitor fluid levels",
      icon: Icon(
        Icons.water,
        color: Color(0xffffffff),
        size: 44,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090f13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
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
                    "https://cdn.discordapp.com/attachments/867367813047779338/921427885888249876/117-1176532_yacht-png-transparent-yacht-side-view-png-png-removebg-preview.png"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 17,
                          decoration: BoxDecoration(
                            color: const Color(0xffdbe2e7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 13,
                            decoration: BoxDecoration(
                              color: const Color(0xff39d2c0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "charge",
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
                height: 10,
              ),
              Center(
                child: RoundedButton(
                    title: "check",
                    color: const Color(0xff4b39ef),
                    onPressed: () {}),
              ),
              const SizedBox(
                height: 20,
              ),
              CarouselSlider(
                  items: items,
                  options: CarouselOptions(
                    height: 150,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ))
            ],
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
      width: 180,
      height: 180,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
           Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
            child: icon,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: AutoSizeText(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Lexend Deca',
                  color: const Color(0xB3FFFFFF),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}