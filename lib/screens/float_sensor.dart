import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:foka_app_v1/utils/userSimplePreferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class FloatSensor extends StatefulWidget {
  const FloatSensor({Key? key}) : super(key: key);

  // FloatSensor({this.hubId, this.deviceId});

  // final hubId, deviceId;

  static const String id = 'float_sensor';

  @override
  _FloatSensorState createState() => _FloatSensorState();
}

class _FloatSensorState extends State<FloatSensor> {
  late String hubId;
  late String deviceId;

  late int floatValue = Preferences.getFloatValue() ?? 0;

  late String deviceName;
  late bool bilgeState = false;

  bool showSpinner = true;

  int floatSensorTimer = 30;

  late dynamic settings = [];

  late MqttServerClient client;

  @override
  void initState() {
    getValues();
    // getSettings();
    // deviceName = settings['serial'];
    // bilgeState = settings['alert_bilge'] == 1 ? true : false;
    print('running init');
    // TODO: implement initState
    super.initState();
    Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => change());

    void start() async {
      await connectClient();
      client.subscribe("/$deviceId", MqttQos.atLeastOnce);
      // client.subscribe("/DEMOHUB001/FKB001FLOAT", MqttQos.atLeastOnce);
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
      floatValue = int.parse(payload);

      showSpinner = false;
      floatSensorTimer = 30;

      print("message_received : $floatValue");
    });

    return client;
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
      if (floatSensorTimer-- < 0) showSpinner = true;
      floatValue = floatValue;
    });
    Preferences.setFloatValue(floatValue);
  }

  void getSettings() {
    // settings = widget.settings;
  }

  void getValues() {
    hubId = Data().getHubId();
    deviceId = Data().getDevices()[0]['serial'];
  }

  settingsUpdate() {
    // ApiCalls.updateBilgeSettingsApi(deviceName, {
    //   "alert_fluid": bilgeState ? '1' : '0',
    // });
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
        title: const Text(
          'Float Sensor',
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Bilge Settings',
                style: settingsHeadingTextStyle,
              ),
            ),
            ListTile(
              title: Text(
                'Enable Alerts',
                style: settingsLeadingTextStyle,
              ),
              trailing: Switch(
                value: bilgeState,
                onChanged: (value) {
                  setState(() {
                    bilgeState = value;
                    settingsUpdate();
                  });
                },
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.blueGrey,
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ApiCalls.deleteDevice(deviceId);
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
      backgroundColor: const Color(0xff090f13),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: Lottie.network('https://assets9.lottiefiles.com/packages/lf20_6s2xGI.json'),
        opacity: 0.8,
        child: Center(
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
      ),
    );
  }
}
