import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/battery_monitor.dart';
import 'package:foka_app_v1/screens/chose_device.dart';
import 'package:foka_app_v1/screens/float_sensor.dart';
import 'package:foka_app_v1/screens/location_tracker.dart';
import 'package:foka_app_v1/screens/security_monitor.dart';
import 'package:foka_app_v1/screens/smart_connect.dart';
import 'package:foka_app_v1/screens/ths_monitor.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progresso/progresso.dart';

import 'fluid_monitor.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  // HomeScreen({this.hubId, this.boatName});

  // final hubId, boatName;

  static const String id = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController controller;

  List<String> deviceNames = [
    'THS Monitor',
    'Fluid Monitor',
    'Float Sensor',
    'Smart Connect',
    'Location Tracker',
    'Security Monitor',
  ];

  late List<int> activeOrNot = [];
  late List<dynamic> devices = [];
  late List<dynamic> connectedDevices = [];
  late List<Widget> items = [];
  late String hubId;

  @override
  void initState() {
    hubId = Data().getHubId();
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    getDevices();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getDevices() async {
    devices = await ApiCalls().getHubDevices(hubId);
    connectedDevices = await ApiCalls().getConnectedDevices(hubId);
    setState(() {
      items = buildItems(devices);
    });
  }

  Future<List> getDiagonsticData() async {
    activeOrNot.clear();
    List hubDevices = await ApiCalls().getHubDevicesCount(hubId);
    List connectedDevices = await ApiCalls().getConnectedDevicesCount(hubId);
    for (int i = 0; i < hubDevices.length; i++) {
      activeOrNot.add(hubDevices[i] == 0 ? -1 : hubDevices[i] - connectedDevices[i]);
    }
    return Future<List>.value(activeOrNot);
  }

  List<Widget> buildItems(dynamic devices) {
    print(devices);
    List<Widget> items = [
      InkWell(
        onTap: devices[0].length == 0
            ? () {}
            : () async {
                getDevices();
                await ApiCalls().getTHSSettingsApi(devices[0][0]['serial']).then((value) {
                  print(value);
                  Data().setDevices(devices[0]);
                  Data().setSettings(value);
                  Navigator.pushNamed(context, THSScreen.id);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return THSScreen(
                  //     hubId: hubId,
                  //     devices: devices[0],
                  //     settings: value,
                  //   );
                  // }));
                });
                // await ApiCalls().getTHSSettingsApi(deviceName).then((value) {
                //   print(value);
                //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                //     return THSSettingsPage(settings: value);
                //   }));
                // });
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return THSScreen(
                //     hubId: hubId,
                //     devices: devices[0],
                //   );
                // }));
              },
        child: DeviceCard(
          color: devices[0].length == 0 ? Colors.pink.shade600.withOpacity(0.2) : Colors.pink.shade600,
          title: "THS Monitor",
          description: "Tap here to more info",
          icon: Icon(
            Icons.thermostat,
            color: devices[0].length == 0 ? Colors.white.withOpacity(0.2) : const Color(0xffffffff),
            size: 44,
          ),
          opacity: devices[0].length == 0 ? 0.2 : 1,
        ),
      ),
      InkWell(
        onTap: devices[1].length == 0 && devices[2] == 0
            ? () {}
            : () async {
                getDevices();
                await ApiCalls().getUltrasonicSettingsApi(devices[1][0]['serial']).then((value) {
                  print(value);
                  Data().setSettings(value);
                  Data().setDevices(devices[1]);
                  Navigator.pushNamed(context, FluidMonitor.id);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return FluidMonitor(
                  //     hubId: hubId,
                  //     devicesUltrasonic: devices[1],
                  //     settings: value,
                  //   );
                  // }));
                });
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return FluidMonitor(
                //     hubId: hubId,
                //     devicesUltrasonic: devices[1],
                //     devicesFloat: devices[2],
                //   );
                // }));
              },
        child: DeviceCard(
          color: devices[1].length == 0 && devices[2].length == 0 ? const Color(0xff4b39ef).withOpacity(0.2) : const Color(0xff4b39ef),
          title: "Fluid Monitor",
          description: "Tap here to monitor fluid levels",
          icon: Icon(
            Icons.water,
            color: devices[1].length == 0 ? Colors.white.withOpacity(0.2) : const Color(0xffffffff),
            size: 44,
          ),
          opacity: devices[1].length == 0 ? 0.2 : 1,
        ),
      ),
      InkWell(
        onTap: devices[2].length == 0
            ? () {}
            : () {
                Data().setDevices(devices[2]);
                Navigator.pushNamed(context, FloatSensor.id);
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return FloatSensor(
                //     hubId: hubId,
                //     deviceId: devices[2][0]['serial'],
                //   );
                // }));
              },
        child: DeviceCard(
          // color: Color(0xff4b39ef),
          color: devices[2].length == 0 ? Colors.grey.shade900.withOpacity(0.2) : Colors.grey.shade900,
          title: "Float Sensor",
          description: "Tap here to more details",
          icon: Icon(
            Icons.water,
            color: devices[2].length == 0 ? Colors.white.withOpacity(0.2) : const Color(0xffffffff),
            size: 44,
          ),
          opacity: devices[2].length == 0 ? 0.2 : 1,
        ),
      ),
      InkWell(
        onTap: devices[3].length == 0
            ? () {}
            : () async {
                getDevices();
                await ApiCalls().getSmartConnectSettingsApi(devices[3][0]['serial']).then((value) {
                  print(value);
                  Data().setSettings(value);
                  Data().setDevices(devices[3]);
                  Navigator.pushNamed(context, SmartConnect.id);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return SmartConnect(
                  //     hubId: hubId,
                  //     devices: devices[3],
                  //     settings: value,
                  //   );
                  // }));
                });
              },
        child: DeviceCard(
          // color: Color(0xff4b39ef),
          color: devices[3].length == 0 ? Colors.pink.withOpacity(0.2) : Colors.pink,
          title: "Smart Connect",
          description: "Tap here to more details",
          icon: Icon(
            Icons.water,
            color: devices[3].length == 0 ? Colors.white.withOpacity(0.2) : const Color(0xffffffff),
            size: 44,
          ),
          opacity: devices[3].length == 0 ? 0.2 : 1,
        ),
      ),
      InkWell(
        onTap: devices[4].length == 0
            ? () {}
            : () async {
                await ApiCalls().getLocationSettingsApi(devices[4][0]['serial']).then((value) {
                  print(value);
                  Data().setDevices(devices[4]);
                  Data().setSettings(value);
                  Navigator.pushNamed(context, LocationScreen.id);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return LocationScreen(
                  //     hubId: hubId,
                  //     deviceId: devices[4][0]['serial'],
                  //     boatName: Data().getBoatData(),
                  //     settings: value,
                  //   );
                  // }));
                });
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return LocationScreen(
                //     hubId: hubId,
                //     deviceId: devices[4][0]['serial'],
                //     boatName: widget.boatName,
                //   );
                // }));
              },
        child: DeviceCard(
          color: devices[4].length == 0 ? const Color(0xff8b0f32).withOpacity(0.2) : const Color(0xff8b0f32),
          title: "Location Tracker",
          description: "Tap here to locate your boat",
          icon: Icon(
            Icons.location_on,
            color: devices[4].length == 0 ? Colors.white.withOpacity(0.2) : const Color(0xffffffff),
            size: 44,
          ),
          opacity: devices[4].length == 0 ? 0.2 : 1,
        ),
      ),
      InkWell(
        onTap: devices[5].length == 0
            ? () {}
            : () {
                Data().setDevices(devices[5]);
                Navigator.pushNamed(context, SecurityScreen.id);
              },
        child: DeviceCard(
          color: devices[5].length == 0 ? Colors.orange.shade600.withOpacity(0.2) : Colors.orange.shade600,
          title: "Security Monitor",
          description: "Tap here to monitor your boat",
          icon: Icon(
            Icons.security,
            color: devices[5].length == 0 ? Colors.white.withOpacity(0.2) : const Color(0xffffffff),
            size: 44,
          ),
          opacity: devices[5].length == 0 ? 0.2 : 1,
        ),
      ),
      InkWell(
        onTap: devices[6].length == 0
            ? () {}
            : () {
                Data().setDevices(devices[6]);
                Navigator.pushNamed(context, BatteryMonitor.id);
              },
        child: DeviceCard(
          color: devices[6].length == 0 ? Colors.teal.withOpacity(0.2) : Colors.teal,
          title: "Battery Monitor",
          description: "Tap here to monitor your boat",
          icon: Icon(
            Icons.security,
            color: devices[6].length == 0 ? Colors.white.withOpacity(0.2) : const Color(0xffffffff),
            size: 44,
          ),
          opacity: devices[6].length == 0 ? 0.2 : 1,
        ),
      ),
    ];
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     Navigator.pushNamed(context, SelectService.id);
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   elevation: 9,
      //   onPressed: () {
      //     Navigator.pushNamed(context, SelectService.id);
      //   },
      //   label: const Text('Add Device'),
      //   icon: const Icon(Icons.add),
      //   backgroundColor: Colors.lightBlueAccent.shade700,
      // ),
      backgroundColor: const Color(0xff090f13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Boat",
                style: GoogleFonts.lexendDeca(color: const Color(0xff95a1ac), fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Text(
                Data().getBoatName(),
                style: GoogleFonts.lexendDeca(color: const Color(0xffffffff), fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Image.network(
                  "https://cdn.discordapp.com/attachments/867367813047779338/921427885888249876/117-1176532_yacht-png-transparent-yacht-side-view-png-png-removebg-preview.png",
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(8, 13, 8, 12),
              //   child: Progresso(
              //     progressColor: const Color(0xFF39d2c0),
              //     backgroundStrokeWidth: 16,
              //     progressStrokeWidth: 13,
              //     progress: 0.7,
              //     progressStrokeCap: StrokeCap.round,
              //     backgroundStrokeCap: StrokeCap.round,
              //   ),
              //   // child: Row(
              //   //   mainAxisSize: MainAxisSize.max,
              //   //   mainAxisAlignment: MainAxisAlignment.center,
              //   //   children: [
              //   //     Stack(
              //   //       children: [
              //   //         Container(
              //   //           width: MediaQuery.of(context).size.width * 0.9,
              //   //           height: 17,
              //   //           decoration: BoxDecoration(
              //   //             color: const Color(0xffdbe2e7),
              //   //             borderRadius: BorderRadius.circular(8),
              //   //           ),
              //   //         ),
              //   //         Padding(
              //   //           padding:
              //   //               const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
              //   //           child: Container(
              //   //             width: MediaQuery.of(context).size.width * 0.4,
              //   //             height: 13,
              //   //             decoration: BoxDecoration(
              //   //               color: const Color(0xff39d2c0),
              //   //               borderRadius: BorderRadius.circular(8),
              //   //             ),
              //   //           ),
              //   //         ),
              //   //       ],
              //   //     ),
              //   //   ],
              //   // ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Column(
              //         children: [
              //           Text(
              //             "Charge",
              //             style: GoogleFonts.lexendDeca(color: const Color(0xff95a1ac), fontSize: 14, fontWeight: FontWeight.w400),
              //           ),
              //           Text(
              //             "70%",
              //             style: GoogleFonts.lexendDeca(color: const Color(0xffffffff), fontSize: 28, fontWeight: FontWeight.w700),
              //           ),
              //         ],
              //       ),
              //       Column(
              //         children: [
              //           Text(
              //             "Status",
              //             style: GoogleFonts.lexendDeca(color: const Color(0xff95a1ac), fontSize: 14, fontWeight: FontWeight.w400),
              //           ),
              //           Text(
              //             "Good",
              //             style: GoogleFonts.lexendDeca(color: const Color(0xFF39d2c0), fontSize: 28, fontWeight: FontWeight.w700),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              Center(
                child: RoundedButton(
                  title: 'Add Device',
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, SelectService.id);
                  },
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Center(
                child: RoundedButton(
                  title: "Start Diagnostic",
                  color: const Color(0xFF107896),
                  onPressed: () async {
                    await getDiagonsticData().then((value) {
                      print(value);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Center(child: const Text('Diagonstic Results')),
                            content: Container(
                              width: double.minPositive,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: deviceNames.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      deviceNames[index],
                                      style: homeScreenDialogTextStyle,
                                    ),
                                    trailing: value[index] == -1
                                        ? const Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          )
                                        : value[index] == 0
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : const Icon(
                                                Icons.info,
                                                color: Colors.orange,
                                              ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    });
                  },
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              // Center(
              //   child: CircularProgressIndicator(
              //     backgroundColor: Colors.white,
              //     // color: Colors.white,
              //     value: controller.value,
              //     semanticsLabel: 'Linear progress indicator',
              //   ),
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              CarouselSlider(
                items: items,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.23,
                  viewportFraction: 0.63,
                  enlargeCenterPage: true,
                  // onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    Key? key,
    required this.color,
    required this.title,
    required this.description,
    required this.icon,
    this.opacity = 1,
  }) : super(key: key);

  final Icon icon;
  final String title;
  final String description;
  final Color color;
  final double opacity;
  // final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x37000000),
            offset: Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      width: 220,
      height: 220,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: icon,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: AutoSizeText(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(color: const Color(0xffffffff).withOpacity(opacity), textStyle: const TextStyle(fontSize: 18)),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Lexend Deca',
                color: const Color(0xB3FFFFFF).withOpacity(opacity),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
