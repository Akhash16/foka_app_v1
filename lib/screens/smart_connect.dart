import 'dart:async';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/main.dart';
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

  late List<dynamic> relay = [
    {"name": "Relay 1", "value": 0, "usable": true},
    {"name": "Relay 2", "value": 0, "usable": true},
    {"name": "Relay 3", "value": 0, "usable": true},
    {"name": "Relay 4", "value": 0, "usable": true},
    {"name": "Relay 5", "value": 0, "usable": true},
    {"name": "Relay 6", "value": 0, "usable": true},
    {"name": "Relay 7", "value": 0, "usable": true},
    {"name": "Relay 8", "value": 0, "usable": true},
  ];

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

  void publish(String toPublish) {
    final pubTopic = '/$hubId/$deviceId';
    final builder = MqttClientPayloadBuilder();
    builder.addString(toPublish);
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void change(int index) {
    publish('{relay${index + 1}: ${relay[index]["value"]}}');
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
    String newName = '';

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
                child: Text(
                  'Smart Connect Settings',
                  style: settingsHeadingTextStyle,
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: relay.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.edit, color: Colors.white),
                      title: Text(
                        relay[index]['name'],
                        style: settingsTitleTextStyle,
                      ),
                      trailing: Switch(
                        value: relay[index]['usable'],
                        onChanged: (value) {
                          setState(() {
                            relay[index]['value'] = 0;
                            relay[index]['usable'] = value;
                            // settingsUpdate();
                          });
                        },
                        inactiveTrackColor: Colors.white,
                        inactiveThumbColor: Colors.blueGrey,
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      // endDrawer: Drawer(
      //   backgroundColor: Colors.black,
      //   child: ListView(
      //     children: [
      //       ListTile(
      //         title: Text(
      //           relay[0]['name'],
      //           style: settingsTitleTextStyle,
      //         ),
      //         trailing: Switch(
      //           value: relay[0]['usable'],
      //           onChanged: (value) {
      //             setState(() {
      //               relay[0]['usable'] = value;
      //               // settingsUpdate();
      //             });
      //           },
      //           inactiveTrackColor: Colors.white,
      //           inactiveThumbColor: Colors.blueGrey,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      backgroundColor: const Color(0xff090f13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
          child: GridView.builder(
              itemCount: relay.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: relay[index]['usable'] ? 1 : 0.3,
                  duration: const Duration(milliseconds: 500),
                  child: Card(
                    color: const Color(0xff1d2429),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              relay[index]['name'],
                              style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: !relay[index]['usable']
                                  ? null
                                  : () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            // return ChangeRelayName(
                                            //   index: index,
                                            //   relay: relay,
                                            // );
                                            return Container(
                                              color: Colors.black45,
                                              child: Container(
                                                height: MediaQuery.of(context).size.height * 0.75,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff1d2429).withOpacity(0.75),
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(20.0),
                                                    topRight: Radius.circular(20.0),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(18.0),
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          'Change Name',
                                                          style: settingsHeadingTextStyle,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(18.0),
                                                          child: TextField(
                                                            decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              labelText: 'Change Relay Name',
                                                              labelStyle: TextStyle(color: Colors.white),
                                                              hintText: 'Enter New Name for Relay',
                                                              hintStyle: TextStyle(color: Colors.white54),
                                                            ),
                                                            style: TextStyle(color: Colors.yellow.shade200),
                                                            onChanged: (value) {
                                                              newName = value;
                                                            },
                                                          ),
                                                        ),
                                                        RoundedButton(
                                                          title: 'Change',
                                                          color: Colors.lightBlueAccent,
                                                          onPressed: () {
                                                            if (newName != '') {
                                                              setState(() {
                                                                relay[index]['name'] = newName;
                                                                newName = '';
                                                              });
                                                            }
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                              color: Colors.white,
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        ToggleSwitch(
                          cornerRadius: 20,
                          animate: true,
                          fontSize: 10,
                          inactiveBgColor: const Color(0xff303030),
                          inactiveFgColor: Colors.white,
                          minWidth: MediaQuery.of(context).size.width * 0.15,
                          initialLabelIndex: relay[index]['value'],
                          totalSwitches: 2,
                          labels: const ['OFF', 'ON'],
                          customTextStyles: [
                            GoogleFonts.montserrat(fontWeight: FontWeight.w400, color: Colors.white),
                            GoogleFonts.montserrat(fontWeight: FontWeight.w400, color: Colors.white),
                          ],
                          changeOnTap: relay[index]['usable'],
                          onToggle: (value) {
                            // print('switched to: $index');
                            relay[index]['value'] = value;
                            change(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
