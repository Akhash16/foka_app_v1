import 'dart:async';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DoorSecurity extends StatefulWidget {
  const DoorSecurity({Key? key}) : super(key: key);

  static const String id = 'door_security';

  @override
  State<DoorSecurity> createState() => _DoorSecurityState();
}

class _DoorSecurityState extends State<DoorSecurity> {
  int doorValue = 0;
  int doorSensorTimer = 30;
  bool showSpinner = true;
  bool doorState = false;

  List dropdownItemListDoorMonitor = [
    {'label': 'Door Sensor 1', 'value': 'FKB001DM'},
    {'label': 'Door Sensor 2', 'value': 'FKB002DM'},
  ];

  String deviceId = 'FKB001DM';

  late MqttServerClient client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (doorSensorTimer-- < 0) {
        setState(() {
          showSpinner = true;
        });
      }
    });

    void start() async {
      await connectClient();
      client.subscribe("/FKB001DM", MqttQos.atLeastOnce);
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
      doorValue = int.parse(payload);

      showSpinner = false;
      doorSensorTimer = 30;

      setState(() {});

      print("message_received : $doorValue");
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
        centerTitle: true,
        title: CoolDropdown(
          dropdownHeight: dropdownItemListDoorMonitor.length * 70 > 300 ? 300 : dropdownItemListDoorMonitor.length * 70,

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
          dropdownList: dropdownItemListDoorMonitor,
          onChange: (_) async {
            await connectClient();
            client.subscribe("/" + _['value'], MqttQos.atLeastOnce);
            // client.subscribe("/" + _['value'] + "FLOAT", MqttQos.atLeastOnce);
            deviceId = _['value'];
            // await ApiCalls.getUltrasonicSettingsApi(deviceId).then((value) {
            //   getSettings(value);
            // });
            print("The device number is " + deviceId);
            setState(() {});
          },
          defaultValue: dropdownItemListDoorMonitor[0],
          // placeholder: 'insert...',
        ),
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
              padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
              child: Text(
                'Door Settings',
                style: settingsHeadingTextStyle,
              ),
            ),
            ListTile(
              title: Text(
                'Enable Alerts',
                style: settingsHeadingTextStyle,
              ),
              trailing: Switch(
                value: doorState,
                onChanged: (value) {
                  setState(() {
                    doorState = value;
                    // settingsUpdate();
                  });
                },
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.blueGrey,
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
                        'Door Status',
                        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      doorValue == 0 ? 'Normal' : 'Check Door',
                      style: GoogleFonts.montserrat(color: doorValue == 0 ? Colors.green : Colors.red, fontSize: 25, fontWeight: FontWeight.w500),
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
