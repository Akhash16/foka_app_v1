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

class _BatteryMonitorState extends State<BatteryMonitor> {
  var b1Percentage = 75, b2Percentage = 60;
  List<Color> colors = [Color(0xff45C55C),Color(0xff5BBBFC)];
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
            onPressed: () {
              // Navigator.pushNamed(context, THSSettingsPage.id);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularStepProgressIndicator(
                
                gradientColor: LinearGradient(colors: colors),
                child: Center(
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.flash_on,color: Colors.white,size: 40,),
                      Text(
                        "$b1Percentage"+" %",
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                totalSteps: 100,
                currentStep: b1Percentage,
                
                stepSize: 1,
                selectedColor: Colors.greenAccent,
                unselectedColor: Colors.grey[500],
                padding: 0,
                width: MediaQuery.of(context).size.width*0.5,
                height:MediaQuery.of(context).size.width*0.5,
                selectedStepSize: 20,
                roundedCap: (_, __) => true,
              ),
              CircularStepProgressIndicator(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flash_on,color: Colors.white,size: 40,),
                      Text(
                        "$b2Percentage"+" %",
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                totalSteps: 100,
                currentStep: b2Percentage,
                stepSize: 5,
                selectedColor: Colors.greenAccent,
                unselectedColor: Colors.grey[500],
                padding: 0,
                 width: MediaQuery.of(context).size.width*0.5,
                height:MediaQuery.of(context).size.width*0.5,
                selectedStepSize: 20,
                roundedCap: (_, __) => true,
                
              ),
              
              
            ],
          ),
        ),
      ),
    );
  }
}
