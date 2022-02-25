import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
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

  var b1Percentage = 75.0, b2Percentage = 95.0;
  List<Color> colors = [const Color(0xff45C55C), const Color(0xff5BBBFC)];
  List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: Colors.lightBlueAccent,
      data: [0.2, 0.6, 0.55, 0.7, 0.45,0.5],
    ),
    Feature(
      title: "Drink Water",
      color: Colors.greenAccent,
      data: [0.25, 0.69, 0.57, 0.62, 0.83,0.61],
    ),
  ];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
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
                              fontSize: 35,
                              fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(text: b1Percentage.toStringAsFixed(0)),
                            const TextSpan(
                                text: " %",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                totalSteps: 100,
                currentStep: animation1.value.toInt(),
                stepSize: 12,
                selectedColor:  Colors.lightBlueAccent,
                unselectedColor: Colors.grey[700],
                padding: 0,
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                selectedStepSize: 12,
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
                              fontSize: 35,
                              fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(text: b2Percentage.toStringAsFixed(0)),
                            const TextSpan(
                                text: " %",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                totalSteps: 100,
                currentStep: animation2.value.toInt(),
                stepSize: 12,
                selectedColor: Colors.greenAccent,
                unselectedColor: Colors.grey[700],
                padding: 0,
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                selectedStepSize: 12,
                roundedCap: (_, __) => true,
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),
          //   child: SfCartesianChart(
          //     enableAxisAnimation: true,
          //     primaryXAxis: DateTimeAxis(
          //       title: AxisTitle(
          //         text: 'Time',
          //         textStyle: GoogleFonts.montserrat(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.w300),
          //       ),
          //     ),
          //     primaryYAxis: NumericAxis(
          //       title: AxisTitle(
          //         text: 'Voltage',
          //         textStyle: GoogleFonts.montserrat(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.w300),
          //       ),
          //     ),
          //     // primaryXAxis: DateTimeAxis(name: "Time"),
          //     series: <ChartSeries>[
          //       LineSeries<VoltageTimeStamp, DateTime>(
          //         color: Colors.greenAccent,
          //         xAxisName: "Time",
          //         yAxisName: "Voltage",
          //         dataSource: chartData,
          //         xValueMapper: (VoltageTimeStamp timeStamp, _) => timeStamp.time,
          //         yValueMapper: (VoltageTimeStamp timeStamp, _) => timeStamp.voltage,
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            width:  MediaQuery.of(context).size.width,
            child: LineGraph(
              features: features,
              size: const Size(320, 400),
              labelX: const ['6:30', '7:30', '8:30','9:30','10:30','11:30'],
              labelY: const ['15V', '20V', '25V', '30V', '35V'],
              
              graphColor: Colors.white30,
              graphOpacity: 0.2,
              
              descriptionHeight: 130,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

// class VoltageTimeStamp {
//   VoltageTimeStamp(this.voltage, this.time);
//   final DateTime time;
//   final double voltage;
// }
