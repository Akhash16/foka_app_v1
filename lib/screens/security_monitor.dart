import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/snaps_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);
  static const id = "security_monitor";

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;

  late Animation colorAnimation1;
  late Animation colorAnimation2;

  bool alertStatus = false;
  int sliderValue = 1000;

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    controller2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    controller3 = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    colorAnimation1 = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(controller2)
      ..addListener(() {
        setState(() {});
      });

    colorAnimation2 = ColorTween(
      begin: Colors.redAccent.withOpacity(0.3),
      end: Colors.greenAccent.withOpacity(0.3),
    ).animate(controller3)
      ..addListener(() {
        setState(() {});
      });

    controller1.forward();
    controller2.forward();
    controller3.forward();

    checkIsAlert();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
  }

  void checkIsAlert() async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (!alertStatus) {
        controller1.reverse();
        controller2.reverse();
        controller3.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _currIndex;
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
        title: const Text(
          'Security Monitor',
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
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Security Settings',
                style: settingsHeadingTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListTile(
                leading: Text(
                  'Sensitivity : ',
                  style: GoogleFonts.montserrat(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                title: Text(
                  sliderValue.toString(),
                  style: settingsTitleTextStyle,
                ),
              ),
            ),
            Slider(
              value: sliderValue.toDouble(),
              onChanged: (value) => setState(() {
                sliderValue = value.round();
              }),
              min: 100,
              max: 5000,
              label: sliderValue.toString(),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 35),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Color(0xff277D8E),
                          color: colorAnimation1.value,
                          // color: alertStatus ? Colors.greenAccent.shade700 : Colors.red.shade600,
                          boxShadow: [
                            BoxShadow(
                              color: colorAnimation2.value,
                              // color: alertStatus ? Colors.greenAccent.shade700.withOpacity(0.3) : Colors.red.shade600.withOpacity(0.3),
                              spreadRadius: 10,
                              blurRadius: 7,
                              offset: const Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        child: Lottie.network(
                          'https://assets1.lottiefiles.com/private_files/lf30_dqbik4tt.json',
                          // 'https://assets4.lottiefiles.com/packages/lf20_qf1pt6ua.json',
                          // 'https://assets4.lottiefiles.com/packages/lf20_3dtypvor.json',
                          controller: controller1,
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            alertStatus = !alertStatus;
                            if (alertStatus) {
                              controller1.forward();
                              controller2.forward();
                              controller3.forward();
                            } else {
                              controller1.reverse();
                              controller2.reverse();
                              controller3.reverse();
                            }
                          });
                        },
                        child: Lottie.network(
                          'https://assets7.lottiefiles.com/packages/lf20_egjaXa.json',
                          controller: controller1,
                        ),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: const Color(0xff84BEC9),
                        color: colorAnimation2.value,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade700.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                            // changes position of shadow
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.24,
                      height: MediaQuery.of(context).size.width * 0.24,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(alertStatus ? "ON" : "OFF", style: GoogleFonts.montserrat(fontSize: 40, fontWeight: FontWeight.w400, color: Colors.white)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedButton(
                title: "Snapshots",
                // color: const Color(0xff277D8E),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, SnapsScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
