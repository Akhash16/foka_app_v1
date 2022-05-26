import 'dart:async';

import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class BatteryMonitor extends StatefulWidget {
  const BatteryMonitor({Key? key}) : super(key: key);

  static const id = "battery_monitor";

  @override
  _BatteryMonitorState createState() => _BatteryMonitorState();
}

class _BatteryMonitorState extends State<BatteryMonitor> with TickerProviderStateMixin {
  late AnimationController animationController1, animationController2;
  late Animation animation1, animation2, animation3;

  late MqttServerClient client;
  List temp = [0, 0];

  bool isMqttValueRecieved = false;

  double b1Percentage = 10.0, b2Percentage = 20.0;
  List<Color> colors = [const Color(0xff45C55C), const Color(0xff5BBBFC)];
  List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: Colors.lightBlueAccent,
      data: [0.2, 0.6, 0.55, 0.7, 0.45, 0.5],
    ),
    Feature(
      title: "Drink Water",
      color: Colors.greenAccent,
      data: [0.25, 0.69, 0.57, 0.62, 0.83, 0.61],
    ),
  ];

  bool alertState = false;

  String houseBatteryDropdown = '12V';
  String engineBatteryDropdown = '12V';

  @override
  void initState() {
    super.initState();
    animationController1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    animationController2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    animation1 = Tween<double>(begin: 0.0, end: 100).animate(animationController1)
      ..addListener(() {
        setState(() {});
      });
    animation2 = Tween<double>(begin: 100.0, end: b1Percentage).animate(animationController2)
      ..addListener(() {
        setState(() {});
      });
    animation3 = Tween<double>(begin: 100.0, end: b2Percentage).animate(animationController2)
      ..addListener(() {
        setState(() {});
      });
    animationController1.forward();

    print('running init');
    // TODO: implement initState
    Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => change());

    void start() async {
      await connectClient();
      client.subscribe("/${Data().getHubId()}/${Data().getDevices()[0]['serial']}", MqttQos.atLeastOnce);
      // client.subscribe("/DEMOHUB001/FKB001FLOAT", MqttQos.atLeastOnce);
    }

    start();

    super.initState();
  }

  Future<MqttServerClient> connectClient() async {
    print('connect started');
    client = MqttServerClient.withPort('164.52.212.96', MyApp.clientId, 1883);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 20;

    print('final con');
    final connMessage = MqttConnectMessage()
        .authenticateAs('admin', 'smartboat@rec&adr')
        // ignore: deprecated_member_use
        .withClientIdentifier(MyApp.clientId)
        .keepAliveFor(6000)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    print('try');
    try {
      await client.connect();
    } catch (e) {
      print('catch');
      print('Exception: $e');
      client.disconnect();
    }

    print('try done');
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}>');
      temp = payload.split(',');
      print("message_received : $temp");
    });

    return client;
  }

  // connection succeeded
  void onConnected() {
    print('Connected');
  }

// unconnected
  void onDisconnected() {
    print('Disconnected');
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String? topic) {
    print('Unsubscribed topic: $topic');
  }

// PING response received
  void pong() {
    print('Ping response client callback invoked');
  }

  void change() {
    if (!isMqttValueRecieved) {
      animationController2.forward();
    }
    setState(() {
      print(isMqttValueRecieved);
      b1Percentage = double.parse(temp[0]);
      b2Percentage = double.parse(temp[1]);
    });
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
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Battery Settings',
                style: settingsHeadingTextStyle,
              ),
            ),
            ListTile(
              title: Text(
                'Enable Alerts',
                style: settingsLeadingTextStyle,
              ),
              trailing: Switch(
                value: alertState,
                onChanged: (value) {
                  setState(() {
                    alertState = value;
                    // settingsUpdate();
                  });
                },
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.blueGrey,
              ),
            ),
            ListTile(
              title: Text(
                'House Battery',
                style: settingsLeadingTextStyle,
              ),
              trailing: DropdownButton<String>(
                value: houseBatteryDropdown,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    houseBatteryDropdown = newValue!;
                  });
                },
                items: <String>['12V', '24V', '48V'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(
                'Engine Battery',
                style: settingsLeadingTextStyle,
              ),
              trailing: DropdownButton<String>(
                value: engineBatteryDropdown,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    engineBatteryDropdown = newValue!;
                  });
                },
                items: <String>['12V', '24V', '48V'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // ApiCalls.deleteDevice(deviceId);
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade600)),
                child: Text(
                  "Delete Device",
                  style: GoogleFonts.lexendDeca(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
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
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(text: b1Percentage.toStringAsFixed(1)),
                                const TextSpan(text: " V", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    totalSteps: 100,
                    currentStep: animation1.value.toInt(),
                    stepSize: 12,
                    selectedColor: Colors.lightBlueAccent,
                    unselectedColor: Colors.grey[700],
                    padding: 0,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    selectedStepSize: 12,
                    roundedCap: (_, __) => true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    b1Percentage > 13.05
                        ? 'Overload'
                        : b1Percentage > 12.37
                            ? 'Excellent'
                            : b1Percentage > 11.96
                                ? 'Good'
                                : b1Percentage > 11.66
                                    ? 'Poor'
                                    : 'Critical',
                    style: TextStyle(
                      color: b1Percentage > 13.05
                          ? Colors.red
                          : b1Percentage > 12.37
                              ? Colors.green
                              : b1Percentage > 11.96
                                  ? Colors.lightGreenAccent
                                  : b1Percentage > 11.66
                                      ? Colors.yellow
                                      : Colors.red,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              Column(
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
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(text: b2Percentage.toStringAsFixed(1)),
                                const TextSpan(text: " V", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    totalSteps: 100,
                    currentStep: animation1.value.toInt(),
                    stepSize: 12,
                    selectedColor: Colors.greenAccent,
                    unselectedColor: Colors.grey[700],
                    padding: 0,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    selectedStepSize: 12,
                    roundedCap: (_, __) => true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    b2Percentage > 24.74
                        ? 'Overload'
                        : b2Percentage > 23.92
                            ? 'Excellent'
                            : b2Percentage > 23.32
                                ? 'Good'
                                : b2Percentage > 23.02
                                    ? 'Poor'
                                    : 'Critical',
                    style: TextStyle(
                      color: b2Percentage > 24.74
                          ? Colors.red
                          : b2Percentage > 23.92
                              ? Colors.green
                              : b2Percentage > 23.32
                                  ? Colors.greenAccent
                                  : b2Percentage > 23.02
                                      ? Colors.yellow
                                      : Colors.red,
                      fontSize: 20.0,
                    ),
                  ),
                ],
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
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: LineGraph(
              features: features,
              size: const Size(320, 400),
              labelX: const ['6:30', '7:30', '8:30', '9:30', '10:30', '11:30'],
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
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }
}

// class VoltageTimeStamp {
//   VoltageTimeStamp(this.voltage, this.time);
//   final DateTime time;
//   final double voltage;
// }
