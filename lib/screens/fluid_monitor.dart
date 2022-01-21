import 'dart:async';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/screens/fluid_settings_page.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:concentric_transition/concentric_transition.dart';

class FluidMonitor extends StatefulWidget {
  // const FluidMonitor({Key? key}) : super(key: key);

  FluidMonitor({this.hubId, this.devicesUltrasonic, this.devicesFloat});

  final hubId, devicesUltrasonic, devicesFloat;

  static const String id = 'fluid_monitor';

  @override
  _FluidMonitorState createState() => _FluidMonitorState();
}

class _FluidMonitorState extends State<FluidMonitor> with TickerProviderStateMixin {
  // List dropdownItemListUltrasonic = [
  //   {'label': 'Fluid Monitor 1', 'value': 'FKB001US'},
  //   {'label': 'Fluid Monitor 2', 'value': 'FKB002US'},
  //   {'label': 'Fluid Monitor 3', 'value': 'FKB003US'},
  //   {'label': 'Fluid Monitor 4', 'value': 'FKB004US'}, // label is required and unique
  //   {'label': 'Fluid Monitor 5', 'value': 'FKB005US'},
  //   {'label': 'Fluid Monitor 6', 'value': 'FKB006US'},
  //   {'label': 'Fluid Monitor 7', 'value': 'FKB007US'},
  // ];

  late List dropdownItemListUltrasonic = [];

  late String hubId;

  int capacity = 100;
  int value = 0;
  int floatValue = 0;
  double toPrint = 0;
  late String deviceId;

  late AnimationController _animationController;
  late Animation _animation;

  bool isFluidScreen = true;

  late MqttServerClient client;

  @override
  void initState() {
    getValues();

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2, milliseconds: 500));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    print('running init');
    // TODO: implement initState
    super.initState();
    Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => change());

    void start() async {
      await connectClient();
      client.subscribe("/$hubId/$deviceId", MqttQos.atLeastOnce);
      client.subscribe("/DEMOHUB001/FKB001FLOAT", MqttQos.atLeastOnce);
    }

    start();
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

      // var parts = payload.split(',');
      // value = int.parse(parts[0]);
      // floatValue = int.parse(parts[1]);

      c[0].topic.contains('US') ? value = int.parse(payload) : floatValue = int.parse(payload);
      print("message_received : $value");
    });

    return client;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
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
      toPrint = (capacity - value) / capacity; // * 100
      floatValue = floatValue;
    });
  }

  void getValues() {
    hubId = widget.hubId;

    List tempDevicesUS = widget.devicesUltrasonic;
    for (final device in tempDevicesUS) {
      dropdownItemListUltrasonic.add({
        'label': device['devicename'],
        'value': device['serial'],
      });
    }

    deviceId = dropdownItemListUltrasonic[0]['value'];
  }

  void getUltrasonicSettingsDataAndPush(String deviceId) async {
    await ApiCalls().getUltrasonicSettingsApi(deviceId).then((value) {
      print(value);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FluidSettingsPage(settings: value);
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CoolDropdown(
          dropdownHeight: dropdownItemListUltrasonic.length * 70 > 300 ? 300 : dropdownItemListUltrasonic.length * 70,

          resultWidth: 200,
          dropdownItemAlign: Alignment.center,
          resultAlign: Alignment.center,
          dropdownBD: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          selectedItemBD: BoxDecoration(
            color: const Color(0xff090f13),
            borderRadius: BorderRadius.circular(10),
          ),
          selectedItemTS: const TextStyle(color: const Color(0xFF6FCC76), fontSize: 20),
          unselectedItemTS: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          resultBD: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff090f13),
          ),
          resultTS: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),

          isTriangle: false,
          dropdownList: dropdownItemListUltrasonic,
          onChange: (_) async {
            await connectClient();
            client.subscribe("/DEMOHUB001/" + _['value'], MqttQos.atLeastOnce);
            client.subscribe("/DEMOHUB001/" + _['value'] + "FLOAT", MqttQos.atLeastOnce);
            deviceId = _['value'];
            print("The device number is " + deviceId);
          },
          defaultValue: dropdownItemListUltrasonic[0],
          // placeholder: 'insert...',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.adjust),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: const BoxDecoration(
                        color: Color(0xfff8f8f8),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      ),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tank Settings',
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            RoundedButton(
                              title: 'Tap to Calibrate',
                              color: Colors.indigo.shade900,
                              onPressed: () {
                                setState(() {
                                  capacity = value;
                                });
                              },
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ],
                        ),
                      )),
                    );
                  });
            },
          ),
          IconButton(
            onPressed: () {
              getUltrasonicSettingsDataAndPush(deviceId);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: const Color(0xff090f13),
      body: Center(
        child: Container(
            child: ConcentricPageView(
          radius: 0,
          verticalPosition: 0.85,
          colors: const [Color(0xff090f13), Color(0xff090f13)],
          itemBuilder: (index, value) {
            int pageIndex = (index % 2);
            return Container(
              child: Stack(
                alignment: Alignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: pageIndex == 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color.fromARGB(255, 27, 28, 30),
                        boxShadow: [
                          BoxShadow(
                            // color: Color.fromARGB(130, 237, 125, 58),
                            color: toPrint >= 0.25 ? Colors.blue : Colors.red,
                            blurRadius: _animation.value,
                            spreadRadius: _animation.value * 0.1,
                          ),
                        ],
                      ),
                      child: LiquidLinearProgressIndicator(
                        center: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              (toPrint * 100).toStringAsFixed(0),
                              // glowColor: Colors.blue,
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '%',
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.black12,
                        valueColor: toPrint >= 0.25 ? const AlwaysStoppedAnimation(Colors.blue) : const AlwaysStoppedAnimation(Colors.red),
                        value: toPrint,
                        borderRadius: 10.0,
                        borderWidth: 1.0,
                        borderColor: Colors.black12,
                        // borderColor: toPrint >= 25 ? Colors.blue : Colors.red,
                        direction: Axis.vertical,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: pageIndex == 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white10,
                            offset: Offset(3.0, 3.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Bilge Status',
                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                                ),
                              ),
                              Text(
                                floatValue == 0 ? 'Normal' : 'Check Bilge',
                                style: GoogleFonts.montserrat(color: floatValue == 0 ? Colors.green : Colors.red, fontSize: 25, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}
