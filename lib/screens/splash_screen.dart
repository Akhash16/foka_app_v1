import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/authentication.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String? user;

  // getUserEmail() async {
  //   return await Authentication().getCurrentUserEmail();
  // }

  void getBoatDataAndPush(String email) async {
    await ApiCalls.getBoatsApi(email).then((value) {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      //   return BoatsPage(boatData: value);
      // }));
      print(value);

      getToken(email);

      Data().setBoatData(value);
      Navigator.popAndPushNamed(context, BoatsPage.id);
    });
    // print(boatData);
    // Navigator.popAndPushNamed(context, BoatsPage.id);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return BoatsPage(boatData: boatData);
    // }));
  }

  void pushToken(String email, String token) {
    ApiCalls.addUserData(email, token);
  }

  void getToken(String email) async {
    await FirebaseMessaging.instance.getToken().then((value) => pushToken(email, value!));
  }

  @override
  void initState() {
    super.initState();
    // ApiCalls.sample();
    onRefresh(Authentication().getCurrentUserEmail());
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      getBoatDataAndPush(user!);
    }

    return Scaffold(
      backgroundColor: const Color(0xff090f13),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Lottie.asset(
            "assets/animation.json",
          ),
        ),
      ),
    );
  }
}
