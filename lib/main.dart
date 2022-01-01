import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/fluid_monitor.dart';
import 'package:foka_app_v1/screens/add_boat_screen.dart';
import 'package:foka_app_v1/screens/boat_add_data.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:foka_app_v1/screens/forgot_password.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/screens/onboarding.dart';
import 'package:foka_app_v1/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foka_app_v1/screens/smart_connect.dart';
import 'package:foka_app_v1/screens/ths_monitor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final String clientId = Random().nextInt(100000000).toString();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black54.withOpacity(0),
        ),
      ),
      title: "Foka Tech",
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        Onboarding.id: (context) => const Onboarding(),
        ForgotPassword.id: (context) => const ForgotPassword(),
        BoatsPage.id: (context) => const BoatsPage(),
        BoatAddData.id: (context) => const BoatAddData(),
        AddBoatScreen.id: (context) => const AddBoatScreen(),
        FluidMonitor.id: (context) => const FluidMonitor(),
        SmartConnet.id: (context) => const SmartConnet(),
        THSScreen.id: (context) => const THSScreen(),
      },
    );
  }
}
