import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class THSScreen extends StatefulWidget {
  const THSScreen({Key? key}) : super(key: key);
  static const id = "ths_monitor";

  @override
  _THSScreenState createState() => _THSScreenState();
}

class _THSScreenState extends State<THSScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late MqttServerClient client;

  int indexValue = 0;
  double temperature = 21.0;
  double humidity = 34.0;
  int gas = 6000;
  double tempMin = 28.0;
  double tempMax = 30.0;
  List<String> parts = ['6000', '21.0', '34.0'];

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => change());
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

        parts = payload.split(',');
        print("message_received : $parts");
      });

      client.subscribe("/DEMOHUB001/FKB001THS", MqttQos.atLeastOnce);

      return client;
    }

    void start() async {
      await connectClient();
    }

    start();
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
    setState(() {
      gas = int.parse(parts[0]);
      temperature = double.parse(parts[1]);
      humidity = double.parse(parts[2]) <= 100 ? double.parse(parts[2]) : 100;
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
            // _animationController.stop();
            _animationController.dispose();
            super.dispose();
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
        ),
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
          padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ],
              onToggle: (index) {
                // print('switched to: $index');
                indexValue = index;
              },
            ),
            const SizedBox(
              height: 70,
            ),
            Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: indexValue == 0 ? 1.0 : 0.0,
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            temperature.toStringAsFixed(1),
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // const SizedBox(
                          //   width: 20.0,
                          //   child: Divider(
                          //     thickness: 2,
                          //     color: Colors.blue,
                          //   ),
                          // ),
                          Text(
                            "°C",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
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
                            color: temperature > tempMax
                                ? Colors.red
                                : temperature < tempMin
                                    ? Colors.red
                                    : Colors.blue,
                            blurRadius: _animation.value,
                            spreadRadius: _animation.value)
                      ],
                    ),
                  ),
                ),

                // just to diff

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: indexValue == 1 ? 1.0 : 0.0,
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            gas.toStringAsFixed(0),
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'ppm',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
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
                            color: gas < 5000 ? Colors.green : Colors.red,
                            blurRadius: _animation.value,
                            spreadRadius: _animation.value)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 140,
                decoration: BoxDecoration(
                  // color: Colors.white12,
                  color: const Color(0xff1d2429),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Humidity",
                        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/humidity.png',
                            height: 35,
                            width: 35,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            humidity.toStringAsFixed(1) + " %",
                            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
