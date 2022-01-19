import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/authentication.dart';
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
    await ApiCalls().getBoatsApi(email).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return BoatsPage(boatData: value);
      }));
    });
    // print(boatData);
    // Navigator.popAndPushNamed(context, BoatsPage.id);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return BoatsPage(boatData: boatData);
    // }));
  }

  @override
  void initState() {
    super.initState();
    onRefresh(Authentication().getCurrentUserEmail());
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
