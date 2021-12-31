import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FluidMonitor extends StatefulWidget {
  const FluidMonitor({Key? key}) : super(key: key);
  static const String id = 'fluid_monitor';

  @override
  _FluidMonitorState createState() => _FluidMonitorState();
}

class _FluidMonitorState extends State<FluidMonitor> {
  double fluidLevel = 80;
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
          onPressed: () {},
        ),
        title: const Center(child: Text("Fluid Monitor")),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: const Color(0xff090f13),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SfRadialGauge(
          //   title: const GaugeTitle(text: "Fluid Monitor"),
          // ),

          SfRadialGauge(
            axes: [
              RadialAxis(
                  startAngle: 130,
                  endAngle: 50,
                  minimum: 0,
                  maximum: 100,
                  interval: 10,
                  minorTicksPerInterval: 9,
                  showAxisLine: false,
                  radiusFactor: 0.8,
                  labelOffset: 8,
                  ranges: [
                    GaugeRange(
                        startValue: -50,
                        endValue: 0,
                        startWidth: 0.265,
                        sizeUnit: GaugeSizeUnit.factor,
                        endWidth: 0.265,
                        color: Colors.blue),
                    GaugeRange(
                        startValue: 0,
                        endValue: 10,
                        startWidth: 0.265,
                        sizeUnit: GaugeSizeUnit.factor,
                        endWidth: 0.265,
                        color: Colors.teal),
                    GaugeRange(
                        startValue: 10,
                        endValue: 30,
                        startWidth: 0.265,
                        sizeUnit: GaugeSizeUnit.factor,
                        endWidth: 0.265,
                        color: Colors.green),
                    GaugeRange(
                        startValue: 30,
                        endValue: 40,
                        startWidth: 0.265,
                        sizeUnit: GaugeSizeUnit.factor,
                        endWidth: 0.265,
                        color: Colors.yellow),
                    GaugeRange(
                        startValue: 40,
                        endValue: 150,
                        startWidth: 0.265,
                        sizeUnit: GaugeSizeUnit.factor,
                        endWidth: 0.265,
                        color: Colors.red,),
                  ],
                  annotations: [
                    GaugeAnnotation(
                        angle: 90,
                        positionFactor: 0.35,
                        widget: Text('Fluid',
                            style: GoogleFonts.montserrat(
                                color: const Color(0xFFF8B195), fontSize: 20))),
                    GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.8,
                      widget: Text(
                        '  22.5  ',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white),
                      ),
                    )
                  ],
                  pointers:  [
                    NeedlePointer(
                      value: fluidLevel,
                      needleLength: 0.55,
                      lengthUnit: GaugeSizeUnit.factor,
                      needleStartWidth: 0,
                      needleEndWidth: 5,
                      // animationType: AnimationType.easeOutBack,
                      // enableAnimation: true,
                      // animationDuration: 1200,
                      knobStyle:const KnobStyle(
                          knobRadius: 0.06,
                          sizeUnit: GaugeSizeUnit.factor,
                          borderColor: Color(0xFFF8B195),
                          color: Colors.white,
                          borderWidth: 0.035),
                      tailStyle: const TailStyle(
                          color: Color(0xFFF8B195),
                          width: 4,
                          lengthUnit: GaugeSizeUnit.factor,
                          length: 0.15),
                      needleColor:const  Color(0xFFF8B195),
                    )
                  ],
                  axisLabelStyle: const GaugeTextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w400),
                  majorTickStyle: const MajorTickStyle(
                      length: 0.25,
                      lengthUnit: GaugeSizeUnit.factor,
                      thickness: 1.5),
                  minorTickStyle: const MinorTickStyle(
                      length: 0.13,
                      lengthUnit: GaugeSizeUnit.factor,
                      thickness: 1))
            ],
          ),
          RoundedButton(title: "Calibrate", color: const Color(0xFF39d2c0), onPressed: (){},width: 150,),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,18,8,8),
            child: Text("Tank is Empty",style: GoogleFonts.montserrat(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w400),),
          )
        ],
      ),
    );
  }
}


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
