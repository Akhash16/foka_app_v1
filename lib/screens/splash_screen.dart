import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/authentication.dart';

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
    var boatData = await ApiCalls().getBoatsApi(email);
    // Navigator.popAndPushNamed(context, BoatsPage.id);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return BoatsPage(boatData: boatData);
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefresh(Authentication().getCurrentUserEmail());
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
      body: Center(
        child: RoundedButton(
          title: 'Login Screen',
          color: Colors.lightBlueAccent,
          onPressed: () => Navigator.popAndPushNamed(context, LoginScreen.id),
        ),
      ),
    );
  }
}
