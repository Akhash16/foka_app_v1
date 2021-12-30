import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ThsScreen extends StatefulWidget {
  const ThsScreen({Key? key}) : super(key: key);
  static const id = "ths_monitor";

  @override
  _ThsScreenState createState() => _ThsScreenState();
}

class _ThsScreenState extends State<ThsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  int indexValue = 0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090f13),
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: const Icon(Icons.arrow_back_ios_new),
        title: const Center(child: Text("THS")),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 28, 8, 8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
                ToggleSwitch(
                  cornerRadius: 20,
                  animate: true,
                  fontSize: 15,
                  
                  inactiveBgColor: Colors.grey.shade900,
                  inactiveFgColor: Colors.white,
                  minWidth: MediaQuery.of(context).size.width * 0.35,
                  initialLabelIndex: indexValue,
                  totalSwitches: 2,
                  labels: const ['Temperature', 'Smoke'],
                  customTextStyles: [
                    GoogleFonts.montserrat(
                        fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white),
                       GoogleFonts.montserrat(
                        fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white), 
                  ],
                  onToggle: (index) {
                    // print('switched to: $index');
                    indexValue = index;
                  },
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "21",
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 60,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "°C",
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 27, 28, 30),
                      boxShadow: [
                        BoxShadow(
                            // color: Color.fromARGB(130, 237, 125, 58),
                            color: Colors.blue,
                            blurRadius: _animation.value,
                            spreadRadius: _animation.value)
                      ]),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Humidity",
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "34 %",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [],
                )
              ]),
        ),
      ),
    );
  }
}
