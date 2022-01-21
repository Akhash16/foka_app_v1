import 'dart:async';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/screens/make_sure.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SmartConnet extends StatefulWidget {
  // const SmartConnet({Key? key}) : super(key: key);
  SmartConnet({this.hubId, this.devices});

  final hubId, devices;

  static const String id = 'smart_connect';

  @override
  _SmartConnetState createState() => _SmartConnetState();
}

class _SmartConnetState extends State<SmartConnet> {
  int indexValue1 = 0, indexValue2 = 0;
  // late int relay1, relay2;

  List dropdownItemList = [];
  late String hubId;
  late String deviceId;

  late MqttServerClient client;

  @override
  void initState() {
    getValues();
    super.initState();

    void start() async {
      await connectClient();
      client.subscribe("/$hubId/$deviceId", MqttQos.atLeastOnce);
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
    });

    return client;
  }

  @override
  void dispose() {
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

  void publish(toPublish) {
    final pubTopic = '/$hubId/$deviceId';
    final builder = MqttClientPayloadBuilder();
    builder.addString(toPublish);
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void switchOneToggle(value) {
    publish('{relay1: ' + value.toString() + '}');
  }

  void switchTwoToggle(value) {
    publish('{relay2: ' + value.toString() + '}');
  }

  void getValues() {
    hubId = widget.hubId;
    List tempDevices = widget.devices;
    for (final device in tempDevices) {
      dropdownItemList.add({
        'label': device['devicename'],
        'value': device['serial'],
      });
    }

    deviceId = dropdownItemList[0]['value'];
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
          dropdownHeight: dropdownItemList.length * 70 > 300 ? 300 : dropdownItemList.length * 70,
          resultWidth: 180,
          dropdownItemAlign: Alignment.center,
          resultAlign: Alignment.center,
          dropdownBD: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
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
          dropdownList: dropdownItemList,
          onChange: (_) async {
            await connectClient();
            client.subscribe("/$hubId/" + _['value'], MqttQos.atLeastOnce);
            deviceId = _['value'];
            print("The device number is " + _['value']);
          },
          defaultValue: dropdownItemList[0],
          // placeholder: 'insert...',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: const Color(0xff090f13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "Boat Name",
              //     style: GoogleFonts.lexendDeca(
              //         color: const Color(0xffffffff),
              //         fontSize: 28,
              //         fontWeight: FontWeight.w700),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff1d2429),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Relay 1",
                              style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ToggleSwitch(
                            cornerRadius: 20,
                            animate: true,
                            fontSize: 10,
                            inactiveBgColor: const Color(0xff303030),
                            inactiveFgColor: Colors.white,
                            minWidth: MediaQuery.of(context).size.width * 0.15,
                            initialLabelIndex: indexValue1,
                            totalSwitches: 2,
                            labels: const ['OFF', 'ON'],
                            customTextStyles: [
                              GoogleFonts.montserrat(fontWeight: FontWeight.w400, color: Colors.white),
                              GoogleFonts.montserrat(fontWeight: FontWeight.w400, color: Colors.white),
                            ],
                            onToggle: (index) {
                              // print('switched to: $index');
                              switchOneToggle(index);
                              indexValue1 = index;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff1d2429),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Relay 2",
                              style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ToggleSwitch(
                            cornerRadius: 20,
                            animate: true,
                            fontSize: 10,
                            inactiveBgColor: const Color(0xff303030),
                            inactiveFgColor: Colors.white,
                            minWidth: MediaQuery.of(context).size.width * 0.15,
                            initialLabelIndex: indexValue2,
                            totalSwitches: 2,
                            labels: const ['OFF', 'ON'],
                            customTextStyles: [
                              GoogleFonts.montserrat(fontWeight: FontWeight.w400, color: Colors.white),
                              GoogleFonts.montserrat(fontWeight: FontWeight.w400, color: Colors.white),
                            ],
                            onToggle: (index) {
                              // print('switched to: $index');
                              switchTwoToggle(index);
                              indexValue2 = index;
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, MakeSure.id),
                  child: DottedBorder(
                    dashPattern: const [10, 14],
                    strokeWidth: 2,
                    color: Colors.grey.shade600,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_box_outlined,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Tap to add new device",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
