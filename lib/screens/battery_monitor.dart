import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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

  List<VoltageTimeStamp> chartData = [
    VoltageTimeStamp(5, DateTime.parse("2022-02-23 09:14:31")),
    // VoltageTimeStamp(10, DateTime.now()),
    VoltageTimeStamp(15, DateTime.parse("2022-02-23 11:27:00")),
    VoltageTimeStamp(20, DateTime.parse("2022-02-23 13:27:00")),
    VoltageTimeStamp(5, DateTime.parse("2022-02-23 19:14:31")),
    // VoltageTimeStamp(10, DateTime.now()),
    VoltageTimeStamp(15, DateTime.parse("2022-02-23 21:27:00")),
    VoltageTimeStamp(20, DateTime.parse("2022-02-23 23:27:00")),
  ];

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
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
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
                              fontSize: 35,
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
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                selectedStepSize: 20,
                roundedCap: (_, __) => true,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 13, 0),
            child: SfCartesianChart(
              enableAxisAnimation: true,
              primaryXAxis: DateTimeAxis(
                title: AxisTitle(
                  text: 'Time',
                  textStyle: GoogleFonts.montserrat(
                      color: Colors.deepOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Voltage',
                  textStyle: GoogleFonts.montserrat(
                      color: Colors.deepOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ),
              // primaryXAxis: DateTimeAxis(name: "Time"),
              series: <ChartSeries>[
                LineSeries<VoltageTimeStamp, DateTime>(
                  color: Colors.greenAccent,
                  xAxisName: "Time",
                  yAxisName: "Voltage",
                  dataSource: chartData,
                  xValueMapper: (VoltageTimeStamp timeStamp, _) =>
                      timeStamp.time,
                  yValueMapper: (VoltageTimeStamp timeStamp, _) =>
                      timeStamp.voltage,
                ),
              ],
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

class VoltageTimeStamp {
  VoltageTimeStamp(this.voltage, this.time);
  final DateTime time;
  final double voltage;
}
