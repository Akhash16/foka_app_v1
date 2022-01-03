import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/main.dart';
import 'package:foka_app_v1/screens/fluid_settings_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FluidMonitor extends StatefulWidget {
  const FluidMonitor({Key? key}) : super(key: key);
  static const String id = 'fluid_monitor';

  @override
  _FluidMonitorState createState() => _FluidMonitorState();
}

class _FluidMonitorState extends State<FluidMonitor> with TickerProviderStateMixin {
  int capacity = 100;
  int value = 0;
  int floatValue = 0;
  double toPrint = 0;

  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
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
    Future<MqttServerClient> connectClient() async {
      print('connect started');
      MqttServerClient client = MqttServerClient.withPort('164.52.212.96', MyApp.clientId, 1883);
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

        c[0].topic == '/DEMOHUB001/FKB001US' ? value = int.parse(payload) : floatValue = int.parse(payload);
        print("message_received : $value");
      });

      print('something $value');

      client.subscribe("/DEMOHUB001/FKB001US", MqttQos.atLeastOnce);
      client.subscribe("/DEMOHUB001/FKB001FLOAT", MqttQos.atLeastOnce);

      return client;
    }

    void start() async {
      await connectClient();
    }

    start();
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
        title: const Text("Fluid Monitor"),
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
          IconButton(onPressed: () => Navigator.pushNamed(context, FluidSettingsPage.id), icon: const Icon(Icons.settings))
        ],
      ),
      backgroundColor: const Color(0xff090f13),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // Text(
              //     //   (toPrint * 100).toStringAsFixed(0) + ' %',
              //     //   style: const TextStyle(
              //     //     color: Colors.white,
              //     //     fontSize: 30.0,
              //     //   ),
              //     // ),
              //     // const SizedBox(height: 20.0),
              //     RoundedButton(
              //       title: "Calibrate",
              //       color: Colors.lightBlueAccent,
              //       onPressed: () {
              //         setState(() {
              //           capacity = value;
              //         });
              //       },
              //       width: 180,
              //     ),
              //     const SizedBox(height: 20.0),
              //     Text(
              //       floatValue == 0 ? 'Tank Empty' : 'Tank Full',
              //       style: GoogleFonts.montserrat(
              //         color: Colors.white,
              //         fontSize: 25,
              //         fontWeight: FontWeight.w400,
              //       ),
              //     ),
              //   ],
              // ),

              Container(
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
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // SfRadialGauge(
//           //   title: const GaugeTitle(text: "Fluid Monitor"),
//           // ),

//           SfRadialGauge(
//             axes: [
//               RadialAxis(
//                   startAngle: 130,
//                   endAngle: 50,
//                   minimum: 0,
//                   maximum: 100,
//                   interval: 10,
//                   minorTicksPerInterval: 9,
//                   showAxisLine: false,
//                   radiusFactor: 0.8,
//                   labelOffset: 8,
//                   ranges: [
//                     GaugeRange(startValue: -50, endValue: 0, startWidth: 0.265, sizeUnit: GaugeSizeUnit.factor, endWidth: 0.265, color: Colors.blue),
//                     GaugeRange(startValue: 0, endValue: 25, startWidth: 0.265, sizeUnit: GaugeSizeUnit.factor, endWidth: 0.265, color: Colors.red),
//                     GaugeRange(startValue: 25, endValue: 45, startWidth: 0.265, sizeUnit: GaugeSizeUnit.factor, endWidth: 0.265, color: Colors.yellow),
//                     GaugeRange(startValue: 45, endValue: 100, startWidth: 0.265, sizeUnit: GaugeSizeUnit.factor, endWidth: 0.265, color: Colors.green),
//                     // GaugeRange(startValue: 40, endValue: 150, startWidth: 0.265, sizeUnit: GaugeSizeUnit.factor, endWidth: 0.265, color: Colors.red),
//                   ],
//                   annotations: [
//                     GaugeAnnotation(angle: 90, positionFactor: 0.35, widget: Text('Fluid', style: GoogleFonts.montserrat(color: const Color(0xFFF8B195), fontSize: 20))),
//                     GaugeAnnotation(
//                       angle: 90,
//                       positionFactor: 0.8,
//                       widget: Text(
//                         toPrint.toStringAsFixed(0),
//                         style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
//                       ),
//                     )
//                   ],
//                   pointers: [
//                     NeedlePointer(
//                       value: toPrint,
//                       needleLength: 0.55,
//                       lengthUnit: GaugeSizeUnit.factor,
//                       needleStartWidth: 0,
//                       needleEndWidth: 5,
//                       // animationType: AnimationType.easeOutBack,
//                       // enableAnimation: true,
//                       // animationDuration: 1200,
//                       knobStyle: const KnobStyle(knobRadius: 0.06, sizeUnit: GaugeSizeUnit.factor, borderColor: Color(0xFFF8B195), color: Colors.white, borderWidth: 0.035),
//                       tailStyle: const TailStyle(color: Color(0xFFF8B195), width: 4, lengthUnit: GaugeSizeUnit.factor, length: 0.15),
//                       needleColor: const Color(0xFFF8B195),
//                     )
//                   ],
//                   axisLabelStyle: const GaugeTextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
//                   majorTickStyle: const MajorTickStyle(length: 0.25, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
//                   minorTickStyle: const MinorTickStyle(length: 0.13, lengthUnit: GaugeSizeUnit.factor, thickness: 1))
//             ],
//           ),
//           RoundedButton(
//             title: "Calibrate",
//             color: const Color(0xFF39d2c0),
//             onPressed: () {
//               setState(() {
//                 capacity = value;
//               });
//             },
//             width: 250,
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
//             child: Text(
//               floatValue == 0 ? 'Tank Empty' : 'Tank Full',
//               style: GoogleFonts.montserrat(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }


// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

// class FluidMonitor extends StatefulWidget {
//   const FluidMonitor({Key? key}) : super(key: key);

//   static const String id = 'fluid_monitor';

//   @override
//   _FluidMonitorState createState() => _FluidMonitorState();
// }

// class _FluidMonitorState extends State<FluidMonitor> with TickerProviderStateMixin {
//   late AnimationController controller1;
//   late Animation<double> animation1;

//   late AnimationController controller2;
//   late Animation<double> animation2;

//   late AnimationController controller3;
//   late Animation<double> animation3;

//   late AnimationController controller4;
//   late Animation<double> animation4;

//   @override
//   void initState() {
//     super.initState();

//     controller1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
//     animation1 = Tween<double>(begin: 1.9, end: 2.1).animate(CurvedAnimation(parent: controller1, curve: Curves.easeInOut))
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller1.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controller1.forward();
//         }
//       });

//     controller2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
//     animation2 = Tween<double>(begin: 1.8, end: 2.4).animate(CurvedAnimation(parent: controller2, curve: Curves.easeInOut))
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller2.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controller2.forward();
//         }
//       });

//     controller3 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
//     animation3 = Tween<double>(begin: 1.8, end: 2.4).animate(CurvedAnimation(parent: controller3, curve: Curves.easeInOut))
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller3.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controller3.forward();
//         }
//       });

//     controller4 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
//     animation4 = Tween<double>(begin: 1.9, end: 2.1).animate(CurvedAnimation(parent: controller4, curve: Curves.easeInOut))
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller4.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controller4.forward();
//         }
//       });

//     controller4.forward();

//     Timer(const Duration(milliseconds: 800), () {
//       controller3.forward();
//     });
//     //
//     Timer(const Duration(milliseconds: 1600), () {
//       controller2.forward();
//     });
//     //
//     Timer(const Duration(milliseconds: 2000), () {
//       controller1.forward();
//     });
//   }

//   @override
//   void dispose() {
//     controller1.dispose();
//     controller2.dispose();
//     controller3.dispose();
//     controller4.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;

//     double valueController = 0.5;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           CustomPaint(
//             painter: MyPainter(animation1.value * valueController, animation2.value * valueController, animation3.value * valueController, animation4.value * valueController),
//             child: SizedBox(
//               height: h,
//               width: w,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MyPainter extends CustomPainter {
//   final double h1;
//   final double h2;
//   final double h3;
//   final double h4;

//   MyPainter(this.h1, this.h2, this.h3, this.h4);

//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     paint
//       ..color = Colors.blue.withOpacity(.7)
//       ..style = PaintingStyle.fill;

//     var path = Path();
//     path.moveTo(0, size.height / h1);

//     path.cubicTo(size.width * .4, size.height / h2, size.width * .7, size.height / h3, size.width, size.height / h4);

//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// //   @override
// //   Widget build(BuildContext context) {
// //     double value = 0.6;

// //     return Scaffold(
// //       body: LiquidLinearProgressIndicator(
// //         value: value, // Defaults to 0.5.
// //         valueColor: const AlwaysStoppedAnimation(Colors.blue), // Defaults to the current Theme's accentColor.
// //         backgroundColor: const Color(0xFF090F13), // Defaults to the current Theme's backgroundColor.
// //         borderColor: Colors.red,
// //         borderWidth: 0.0,
// //         borderRadius: 0.0,
// //         direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
// //         center: Column(
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           children: [
// //             Text(
// //               (value * 100).toString() + ' %',
// //               style: const TextStyle(
// //                 fontSize: 50.0,
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             // TextButton(
// //             //   child: Text,
// //             // ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
