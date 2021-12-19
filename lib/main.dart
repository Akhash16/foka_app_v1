import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/screens/onboarding.dart';

import 'package:foka_app_v1/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Foka Tech",
      initialRoute: Onboarding.id,
      routes: {
         LoginScreen.id: (context) =>   const LoginScreen(),
        RegisterScreen.id: (context) =>  const RegisterScreen(),
        HomeScreen.id: (context)=> const HomeScreen(),
        Onboarding.id:(context)=> const Onboarding(),
      },
    );
  }
}
