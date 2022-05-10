import 'dart:math';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/add_boat_verification.dart';
import 'package:foka_app_v1/screens/battery_monitor.dart';
import 'package:foka_app_v1/screens/bilge.dart';
import 'package:foka_app_v1/screens/chose_device.dart';
import 'package:foka_app_v1/screens/connect_device.dart';
import 'package:foka_app_v1/screens/float_sensor.dart';
import 'package:foka_app_v1/screens/fluid_monitor.dart';
import 'package:foka_app_v1/screens/add_boat_screen.dart';
import 'package:foka_app_v1/screens/boat_add_data.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:foka_app_v1/screens/fluid_settings_page.dart';
import 'package:foka_app_v1/screens/forgot_password.dart';
import 'package:foka_app_v1/screens/geofence.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/location_tracker.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/screens/make_sure.dart';
import 'package:foka_app_v1/screens/manage_boats_screen.dart';
import 'package:foka_app_v1/screens/onboarding.dart';
import 'package:foka_app_v1/screens/profile_screen.dart';
import 'package:foka_app_v1/screens/qr_code.dart';
import 'package:foka_app_v1/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foka_app_v1/screens/security_monitor.dart';
import 'package:foka_app_v1/screens/settings_screen.dart';
import 'package:foka_app_v1/screens/smart_connect.dart';
import 'package:foka_app_v1/screens/snaps_screen.dart';
import 'package:foka_app_v1/screens/splash_screen.dart';
import 'package:foka_app_v1/screens/ths_monitor.dart';
import 'package:foka_app_v1/screens/ths_settings_page.dart';
import 'package:foka_app_v1/screens/wifi_screen.dart';
import 'package:foka_app_v1/utils/userSimplePreferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Preferences.init();

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
      initialRoute: SplashScreen.id,
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
        FloatSensor.id: (context) => const FloatSensor(),
        SmartConnect.id: (context) => const SmartConnect(),
        THSScreen.id: (context) => const THSScreen(),
        THSSettingsPage.id: (context) => THSSettingsPage(),
        FluidSettingsPage.id: (context) => FluidSettingsPage(),
        BilgeSettingsPage.id: (context) => BilgeSettingsPage(),
        AddBoatVerification.id: (context) => AddBoatVerification(),
        LocationScreen.id: (context) => const LocationScreen(),
        WifiScreen.id: (context) => const WifiScreen(),
        SplashScreen.id: (context) => const SplashScreen(),
        MakeSure.id: (context) => const MakeSure(),
        SelectService.id: (context) => const SelectService(),
        ConnectDevice.id: (context) => const ConnectDevice(),
        QrScreen.id: (context) => const QrScreen(),
        GeoFence.id: (context) => GeoFence(),
        SecurityScreen.id: (context) => const SecurityScreen(),
        SnapsScreen.id: (context) => const SnapsScreen(),
        BatteryMonitor.id: (context) => const BatteryMonitor(),
        SettingScreen.id: (context) => const SettingScreen(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        ManageBoats.id: (context) => const ManageBoats(),
      },
    );
  }
}
