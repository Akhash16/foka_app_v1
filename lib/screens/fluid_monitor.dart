import 'dart:async';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/screens/bilge.dart';
import 'package:foka_app_v1/screens/fluid_settings_page.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:foka_app_v1/utils/userSimplePreferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:concentric_transition/concentric_transition.dart';

class FluidMonitor extends StatefulWidget {
  const FluidMonitor({Key? key}) : super(key: key);

  // FluidMonitor({this.hubId, this.devicesUltrasonic, this.settings});

  // final hubId, devicesUltrasonic, settings;

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
  int value = Preferences.getFluidValue() ?? 0;
  int floatValue = 0;
  double toPrint = 0;
  late String deviceId;

  dynamic settings = [];

  late String deviceName;

  late bool fluidState;
  bool bilgeState = false; // dont put
  late int currentLowerValue;
  int currentUpperValue = 100; //dont put

  late AnimationController _animationController;
  late Animation _animation;

  late MqttServerClient client;

  bool showSpinner = true;
  int fluidMonitorTimer = 30;

  @override
  void initState() {
    getValues();
    // deviceName = settings['serial'];
    // fluidState = settings['alert_fluid'] == 1 ? true : false;
    // currentLowerValue = settings['low_tank'];

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

      // var parts = payload.split(',');
      // value = int.parse(parts[0]);
      // floatValue = int.parse(parts[1]);

      fluidMonitorTimer = 30;
      showSpinner = false;

      value = int.parse(payload);
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
      if (fluidMonitorTimer-- < 0) showSpinner = true;
      toPrint = (capacity - value) / capacity; // * 100
      floatValue = floatValue;
    });
    Preferences.setFluidValue(value);
  }

  void getSettings(dynamic settings) {
    this.settings = settings;
    deviceName = this.settings['serial'];
    fluidState = this.settings['alert_fluid'] == 1 ? true : false;
    currentLowerValue = this.settings['low_tank'];
    capacity = this.settings['calibration_val'];
  }

  void getValues() {
    getSettings(Data.getSettings());
    hubId = Data.getHubId();

    dropdownItemListUltrasonic.clear();

    List tempDevicesUS = Data.getDevices();
    for (final device in tempDevicesUS) {
      dropdownItemListUltrasonic.add({
        'label': device['devicename'],
        'value': device['serial'],
      });
    }

    deviceId = dropdownItemListUltrasonic[0]['value'];
  }

  settingsUpdate() {
    ApiCalls.updateUltrasonicSettingsApi(deviceId, {
      "alert_fluid": fluidState ? '1' : '0',
      "low_tank": currentLowerValue.toString(),
      "calibration_val": capacity.toString(),
    });
  }

  showPickerNumber(BuildContext context, bool isUpperLimit) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 100, initValue: currentLowerValue),
        ]),
        hideHeader: true,
        title: const Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int selectedValue = picker.getSelectedValues()[0] as int;
          setState(() {
            isUpperLimit
                ? currentLowerValue <= selectedValue
                    ? currentUpperValue = selectedValue
                    : null
                : currentUpperValue >= selectedValue
                    ? currentLowerValue = selectedValue
                    : null;
          });
          settingsUpdate();
        }).showDialog(context);
  }

  void getUltrasonicSettingsDataAndPush(String deviceId) async {
    await ApiCalls.getUltrasonicSettingsApi(deviceId).then((value) {
      print(value);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FluidSettingsPage(settings: value);
      }));
    });
  }

  void getFloatSettingsDataAndPush(String deviceId) async {
    await ApiCalls.getBilgeSettingsApi(deviceId).then((value) {
      print(value);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BilgeSettingsPage(settings: value);
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
            // client.subscribe("/DEMOHUB001/" + _['value'] + "FLOAT", MqttQos.atLeastOnce);
            deviceId = _['value'];
            await ApiCalls.getUltrasonicSettingsApi(deviceId).then((value) {
              getSettings(value);
            });
            print("The device number is " + deviceId);
            setState(() {});
          },
          defaultValue: dropdownItemListUltrasonic[0],
          // placeholder: 'insert...',
        ),
        centerTitle: true,
        // actions: [
        //   // IconButton(
        //   //   icon: const Icon(Icons.adjust),
        //   //   onPressed: () {
        //   //     showModalBottomSheet(
        //   //         context: context,
        //   //         builder: (context) {
        //   //           return Container(
        //   //             height: MediaQuery.of(context).size.height * 0.3,
        //   //             decoration: const BoxDecoration(
        //   //               color: Color(0xfff8f8f8),
        //   //               borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        //   //             ),
        //   //             child: Center(
        //   //                 child: Padding(
        //   //               padding: const EdgeInsets.symmetric(vertical: 18.0),
        //   //               child: Column(
        //   //                 mainAxisAlignment: MainAxisAlignment.center,
        //   //                 children: [
        //   //                   Text(
        //   //                     'Tank Settings',
        //   //                     style: GoogleFonts.montserrat(
        //   //                       color: Colors.black,
        //   //                       fontSize: 30,
        //   //                       fontWeight: FontWeight.w400,
        //   //                     ),
        //   //                   ),
        //   //                   const SizedBox(
        //   //                     height: 10.0,
        //   //                   ),
        //   //                   RoundedButton(
        //   //                     title: 'Tap to Calibrate',
        //   //                     color: Colors.indigo.shade900,
        //   //                     onPressed: () {
        //   //                       setState(() {
        //   //                         capacity = value;
        //   //                       });
        //   //                     },
        //   //                     width: MediaQuery.of(context).size.width * 0.7,
        //   //                   ),
        //   //                 ],
        //   //               ),
        //   //             )),
        //   //           );
        //   //         });
        //   //   },
        //   // ),
        //   IconButton(
        //     onPressed: () {
        //       // getUltrasonicSettingsDataAndPush(deviceId);
        //       Scaffold.of(context).openEndDrawer();
        //     },
        //     icon: const Icon(Icons.settings),
        //   )
        // ],
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
                                  settingsUpdate();
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Fluid Monitor Settings',
                  style: settingsHeadingTextStyle,
                ),
              ),
              ListTile(
                title: Text(
                  'Enable Alerts',
                  style: settingsLeadingTextStyle,
                ),
                trailing: Switch(
                  value: fluidState,
                  onChanged: (value) {
                    setState(() {
                      fluidState = value;
                      settingsUpdate();
                    });
                  },
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.blueGrey,
                ),
              ),
              ListTile(
                onTap: () => showPickerNumber(context, false),
                leading: Text(
                  'Lower Limit',
                  style: settingsLeadingTextStyle,
                ),
                title: Text(
                  currentLowerValue.toString(),
                  style: settingsTitleTextStyle,
                  textAlign: TextAlign.end,
                ),
                trailing: settingsTrailingIcon,
              ),
              // ListTile(
              //   onTap: () => showPickerNumber(context, true),
              //   leading: Text(
              //     'Upper Limit',
              //     style: settingsLeadingTextStyle,
              //   ),
              //   title: Text(
              //     currentUpperValue.toString(),
              //     style: settingsTitleTextStyle,
              //     textAlign: TextAlign.end,
              //   ),
              //   trailing: settingsTrailingIcon,
              // ),
              // settingsPageDivider,
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Text(
              //     'Bilge Settings',
              //     style: settingsHeadingTextStyle,
              //   ),
              // ),
              // ListTile(
              //   title: Text(
              //     'Enable Alerts',
              //     style: settingsLeadingTextStyle,
              //   ),
              //   trailing: Switch(
              //     value: bilgeState,
              //     onChanged: (value) {
              //       setState(() {
              //         bilgeState = value;
              //         settingsUpdate();
              //       });
              //     },
              //     inactiveTrackColor: Colors.white,
              //     inactiveThumbColor: Colors.blueGrey,
              //   ),
              // ),
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
      ),
      backgroundColor: const Color(0xff090f13),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: Lottie.network('https://assets9.lottiefiles.com/packages/lf20_6s2xGI.json'),
        opacity: 0.8,
        child: Center(
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
                  color: toPrint >= currentLowerValue / 100 ? Colors.blue : Colors.red,
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
              valueColor: toPrint >= currentLowerValue / 100 ? const AlwaysStoppedAnimation(Colors.blue) : const AlwaysStoppedAnimation(Colors.red),
              value: toPrint,
              borderRadius: 10.0,
              borderWidth: 1.0,
              borderColor: Colors.black12,
              // borderColor: toPrint >= 25 ? Colors.blue : Colors.red,
              direction: Axis.vertical,
            ),
          ),
        ),
      ),
    );
  }
}
