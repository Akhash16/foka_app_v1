import 'dart:async';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/ths_settings_page.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:foka_app_v1/utils/userSimplePreferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class THSScreen extends StatefulWidget {
  const THSScreen({Key? key}) : super(key: key);
  // THSScreen({this.hubId, this.devices, this.settings});

  // final hubId, devices, settings;

  static const id = "ths_monitor";

  @override
  _THSScreenState createState() => _THSScreenState();
}

class _THSScreenState extends State<THSScreen> with SingleTickerProviderStateMixin {
  // List dropdownItemList = [
  //   {'label': 'THS Monitor 1', 'value': 'FKB001THS'},
  //   {'label': 'THS Monitor 2', 'value': 'FKB002THS'},
  //   {'label': 'THS Monitor 3', 'value': 'FKB003THS'},
  //   {'label': 'THS Monitor 4', 'value': 'FKB004THS'}, // label is required and unique
  //   {'label': 'THS Monitor 5', 'value': 'FKB005THS'},
  //   {'label': 'THS Monitor 6', 'value': 'FKB006THS'},
  //   {'label': 'THS Monitor 7', 'value': 'FKB007THS'},
  // ];

  dynamic settings = [];

  List dropdownItemList = [];
  late String hubId;

  late AnimationController _animationController;
  late Animation _animation;
  late MqttServerClient client;

  int indexValue = 0;
  double temperature = Preferences.getTemperature() ?? 21.0;
  double humidity = Preferences.getHumidity() ?? 34.0;
  int gas = Preferences.getGas() ?? 6000;

  late bool tempState;
  late int tempCurrentLowerValue;
  late int tempCurrentUpperValue;

  late bool gasState;
  int gasCurrentLowerValue = 0; // removed in front end.. dont pu
  late int gasCurrentUpperValue;

  late bool humidityState;
  late int humidityCurrentLowerValue;
  late int humidityCurrentUpperValue;

  late String deviceId;

  bool showSpinner = true;

  int ths = 30;

  List<String> xLabel = ['', '', '', '', '', '', '', '', '', '', '', ''];
  List<int> gasList = [];
  List<double> data = [10.0, 0.900, 0.800, 0.700, 0.600, 0.500, 0.400, 0.300, 0.200, 0.100];

  @override
  void initState() {
    getValues();
    // deviceId = settings['serial'];
    // tempState = settings['alert_temp'] == 1 ? true : false;
    // tempCurrentLowerValue = settings['low_temp'];
    // tempCurrentUpperValue = settings['high_temp'];
    // gasState = settings['alert_gas'] == 1 ? true : false;
    // gasCurrentUpperValue = settings['high_gas'];
    // humidityState = settings['alert_humidity'] == 1 ? true : false;
    // humidityCurrentLowerValue = settings['low_hum'];
    // humidityCurrentUpperValue = settings['high_hum'];

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => change());

    void start() async {
      await connectClient();
      client.subscribe("/$deviceId", MqttQos.atLeastOnce);
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

      List parts = payload.split(',');
      print("message_received : $parts");

      showSpinner = false;
      ths = 30;

      gas = int.parse(parts[0]);
      temperature = double.parse(parts[1]);
      humidity = double.parse(parts[2]) <= 100 ? double.parse(parts[2]) : 100;
    });

    // client.subscribe("/DEMOHUB001/FKB001THS", MqttQos.atLeastOnce);

    return client;
  }

  @override
  void dispose() {
    _animationController.dispose();
    client.disconnect();
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
      // xLabel.add('');
      // gasList.add(gas);
      if (ths-- < 0) showSpinner = true;
      data.add(gas / 10000);
      data.removeAt(0);
      print('data' + data.toString());
      Preferences.setTHS(gas, temperature, humidity);
    });
  }

  void getSettings(settings) {
    setState(() {
      this.settings = settings;
      deviceId = this.settings['serial'];
      tempState = this.settings['alert_temp'] == 1 ? true : false;
      tempCurrentLowerValue = this.settings['low_temp'];
      tempCurrentUpperValue = this.settings['high_temp'];
      gasState = this.settings['alert_gas'] == 1 ? true : false;
      gasCurrentUpperValue = this.settings['high_gas'];
      humidityState = this.settings['alert_humidity'] == 1 ? true : false;
      humidityCurrentLowerValue = this.settings['low_hum'];
      humidityCurrentUpperValue = this.settings['high_hum'];
    });
  }

  void getValues() {
    hubId = Data().getHubId();
    getSettings(Data().getSettings());
    List tempDevices = Data().getDevices();
    for (final device in tempDevices) {
      dropdownItemList.add({
        'label': device['devicename'],
        'value': device['serial'],
      });
    }

    deviceId = dropdownItemList[0]['value'];
  }

  settingsUpdate() {
    ApiCalls.updateTHSSettingsApi(deviceId, {
      "alert_temp": tempState ? '1' : '0',
      "low_temp": tempCurrentLowerValue.toString(),
      "high_temp": tempCurrentUpperValue.toString(),
      "alert_gas": gasState ? '1' : '0',
      "high_gas": gasCurrentUpperValue.toString(),
      "alert_hum": humidityState ? '1' : '0',
      "low_hum": humidityCurrentLowerValue.toString(),
      "high_hum": humidityCurrentUpperValue.toString(),
    });
    Data().setSettings(settings);
  }

  // void getTHSSettingsDataAndPush(String deviceId) async {
  //   await ApiCalls.getTHSSettingsApi(deviceId).then((value) {
  //     print(value);
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return THSSettingsPage(settings: value);
  //     }));
  //   });
  // }

  showPickerNumberTemperature(BuildContext context, bool isUpperLimit) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: -50, end: 100, initValue: isUpperLimit ? tempCurrentUpperValue : tempCurrentLowerValue),
        ]),
        hideHeader: true,
        itemExtent: 35.0,
        squeeze: 1,
        title: const Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          var selectedValue = picker.getSelectedValues()[0];
          setState(() {
            isUpperLimit
                ? tempCurrentLowerValue <= selectedValue
                    ? tempCurrentUpperValue = selectedValue
                    : null
                : tempCurrentUpperValue >= selectedValue
                    ? tempCurrentLowerValue = selectedValue
                    : null;
            // settingsUpdate() ? null : tempCurrentLowerValue = previousValue;
            settingsUpdate();
          });
        }).showDialog(context);
  }

  showPickerNumberGas(BuildContext context, bool isUpperLimit) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 10000, jump: 100, initValue: isUpperLimit ? gasCurrentUpperValue : gasCurrentLowerValue),
        ]),
        hideHeader: true,
        itemExtent: 35.0,
        squeeze: 1,
        title: const Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int selectedValue = picker.getSelectedValues()[0] as int;
          setState(() {
            isUpperLimit
                ? gasCurrentLowerValue <= selectedValue
                    ? gasCurrentUpperValue = selectedValue
                    : null
                : gasCurrentUpperValue >= selectedValue
                    ? gasCurrentLowerValue = selectedValue
                    : null;
          });
          settingsUpdate();
        }).showDialog(context);
  }

  showPickerNumberHumidity(BuildContext context, bool isUpperLimit) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 100, initValue: isUpperLimit ? humidityCurrentUpperValue : humidityCurrentLowerValue),
        ]),
        hideHeader: true,
        itemExtent: 35.0,
        squeeze: 1,
        title: const Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int selectedValue = picker.getSelectedValues()[0] as int;
          setState(() {
            isUpperLimit
                ? humidityCurrentLowerValue <= selectedValue
                    ? humidityCurrentUpperValue = selectedValue
                    : null
                : humidityCurrentUpperValue >= selectedValue
                    ? humidityCurrentLowerValue = selectedValue
                    : null;
          });
          settingsUpdate();
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Feature> features = [
      Feature(
        title: "Drink Water",
        color: Colors.lightBlueAccent,
        // data: [0.2, 0.6, 0.55, 0.7, 0.45, 0.5],
        data: data,
      ),
    ];

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
            setState(() {
              ths = 0;
            });
            await connectClient();
            client.subscribe("/" + _['value'], MqttQos.atLeastOnce);
            deviceId = _['value'];
            await ApiCalls.getTHSSettingsApi(deviceId).then((value) {
              getSettings(value);
              print("done");
            });
            print("The device number is " + _['value']);
            setState(() {});
          },
          defaultValue: dropdownItemList[0],
          // placeholder: 'insert...',
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       getTHSSettingsDataAndPush(deviceId);
        //     },
        //     icon: const Icon(Icons.settings),
        //   ),
        // ],
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
            child: Column(
              children: [
                Text('Temperature Settings', style: settingsHeadingTextStyle),
                ListTile(
                  title: Text(
                    'Enable Alerts',
                    style: settingsLeadingTextStyle,
                  ),
                  trailing: Switch(
                    value: tempState,
                    onChanged: (value) {
                      setState(() {
                        tempState = value;
                        settingsUpdate();
                      });
                    },
                    inactiveTrackColor: Colors.white,
                    inactiveThumbColor: Colors.blueGrey,
                  ),
                ),
                ListTile(
                  onTap: () => showPickerNumberTemperature(context, false),
                  leading: Text(
                    'Lower Limit',
                    style: settingsLeadingTextStyle,
                  ),
                  title: Text(
                    tempCurrentLowerValue.toString(),
                    style: settingsTitleTextStyle,
                    textAlign: TextAlign.end,
                  ),
                  trailing: settingsTrailingIcon,
                ),
                ListTile(
                  onTap: () => showPickerNumberTemperature(context, true),
                  leading: Text(
                    'Upper Limit',
                    style: settingsLeadingTextStyle,
                  ),
                  title: Text(
                    tempCurrentUpperValue.toString(),
                    style: settingsTitleTextStyle,
                    textAlign: TextAlign.end,
                  ),
                  trailing: settingsTrailingIcon,
                ),
                settingsPageDivider,
                // Text('Gas Settings', style: settingsHeadingTextStyle),
                // ListTile(
                //   title: Text(
                //     'Enable Alerts',
                //     style: settingsLeadingTextStyle,
                //   ),
                //   trailing: Switch(
                //     value: gasState,
                //     onChanged: (value) {
                //       setState(() {
                //         gasState = value;
                //         settingsUpdate();
                //       });
                //     },
                //     inactiveTrackColor: Colors.white,
                //     inactiveThumbColor: Colors.blueGrey,
                //   ),
                // ),
                // ListTile(
                //   onTap: () => showPickerNumberGas(context, false),
                //   leading: Text(
                //     'Lower Limit',
                //     style: settingsLeadingTextStyle,
                //   ),
                //   title: Text(
                //     gasCurrentLowerValue.toString(),
                //     style: settingsTitleTextStyle,
                //     textAlign: TextAlign.end,
                //   ),
                //   trailing: settingsTrailingIcon,
                // ),
                // ListTile(
                //   onTap: () => showPickerNumberGas(context, true),
                //   leading: Text(
                //     'Upper Limit',
                //     style: settingsLeadingTextStyle,
                //   ),
                //   title: Text(
                //     gasCurrentUpperValue.toString(),
                //     style: settingsTitleTextStyle,
                //     textAlign: TextAlign.end,
                //   ),
                //   trailing: settingsTrailingIcon,
                // ),
                // settingsPageDivider,
                Text(
                  'Humidity Settings',
                  style: settingsHeadingTextStyle,
                ),
                ListTile(
                  title: Text(
                    'Enable Alerts',
                    style: settingsLeadingTextStyle,
                  ),
                  trailing: Switch(
                    value: humidityState,
                    onChanged: (value) {
                      setState(() {
                        humidityState = value;
                        settingsUpdate();
                      });
                    },
                    inactiveTrackColor: Colors.white,
                    inactiveThumbColor: Colors.blueGrey,
                  ),
                ),
                ListTile(
                  onTap: () => showPickerNumberHumidity(context, false),
                  leading: Text(
                    'Lower Limit',
                    style: settingsLeadingTextStyle,
                  ),
                  title: Text(
                    humidityCurrentLowerValue.toString(),
                    style: settingsTitleTextStyle,
                    textAlign: TextAlign.end,
                  ),
                  trailing: settingsTrailingIcon,
                ),
                ListTile(
                  onTap: () => showPickerNumberHumidity(context, true),
                  leading: Text(
                    'Upper Limit',
                    style: settingsLeadingTextStyle,
                  ),
                  title: Text(
                    humidityCurrentUpperValue.toString(),
                    style: settingsTitleTextStyle,
                    textAlign: TextAlign.end,
                  ),
                  trailing: settingsTrailingIcon,
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
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: Lottie.network('https://assets9.lottiefiles.com/packages/lf20_6s2xGI.json'),
        opacity: 0.8,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                              color: temperature > tempCurrentUpperValue
                                  ? Colors.red
                                  : temperature < tempCurrentLowerValue
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
                        child: Text(
                          gas < gasCurrentLowerValue
                              ? 'Low'
                              : gas < gasCurrentUpperValue
                                  ? 'Medium'
                                  : 'High',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 27, 28, 30),
                        boxShadow: [
                          BoxShadow(
                              // color: Color.fromARGB(130, 237, 125, 58),
                              color: gas < gasCurrentLowerValue
                                  ? Colors.green
                                  : gas < gasCurrentUpperValue
                                      ? Colors.yellow
                                      : Colors.red,
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
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: indexValue == 0 ? 1.0 : 0.0,
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
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: indexValue == 1 ? 1.0 : 0.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 180,
                        decoration: BoxDecoration(
                          // color: Colors.white12,
                          color: const Color(0xff1d2429),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: LineGraph(
                            features: features,
                            size: const Size(320, 400),
                            labelX: xLabel,
                            // labelX: const ['6:30', '7:30'],
                            // labelX: const ['6:30', '7:30', '8:30', '9:30', '10:30', '21:30', '26:30', '27:30', '28:30', '29:30', '30:30', '31:30'],
                            labelY: const ['2000', '4000', '6000', '8000', '10000'],
                            graphColor: Colors.white30,
                            graphOpacity: 0.2,
                            descriptionHeight: 130,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
