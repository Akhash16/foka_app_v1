import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class BatteryMonitor extends StatefulWidget {
  const BatteryMonitor({Key? key}) : super(key: key);

  static const id = "battery_monitor";

  @override
  _BatteryMonitorState createState() => _BatteryMonitorState();
}

class _BatteryMonitorState extends State<BatteryMonitor>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation1, animation2;

  var b1Percentage = 75.0, b2Percentage = 100.0;
  List<Color> colors = [const Color(0xff45C55C), const Color(0xff5BBBFC)];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation1 = Tween<double>(begin: 0.0, end: b1Percentage)
        .animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animation2 = Tween<double>(begin: 0.0, end: b2Percentage)
        .animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

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
          'Battery Monitor',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularStepProgressIndicator(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 40,
                    ),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(text: b1Percentage.toStringAsFixed(0)),
                          const TextSpan(
                              text: " %",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              totalSteps: 100,
              currentStep: animation1.value.toInt(),
              stepSize: 20,
              selectedColor: Colors.greenAccent,
              unselectedColor: Colors.grey[700],
              padding: 0,
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              selectedStepSize: 20,
              roundedCap: (_, __) => true,
            ),
            CircularStepProgressIndicator(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 40,
                    ),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(text: b2Percentage.toStringAsFixed(0)),
                          const TextSpan(
                              text: " %",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              totalSteps: 100,
              currentStep: animation2.value.toInt(),
              stepSize: 20,
              selectedColor: Colors.greenAccent,
              unselectedColor: Colors.grey[700],
              padding: 0,
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              selectedStepSize: 20,
              roundedCap: (_, __) => true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
