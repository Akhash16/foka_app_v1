import "package:flutter/material.dart";
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/screens/manage_boats_screen.dart';
import 'package:foka_app_v1/screens/profile_screen.dart';
import 'package:foka_app_v1/screens/splash_screen.dart';
import 'package:foka_app_v1/utils/authentication.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static const id = "settings_screen";

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
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
          'Settings',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
             
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SettingsOptions(
            icon: const Icon(
              Icons.edit,
              color: Color(0xff7E8187),
            ),
            title: 'Edit Profile',
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.id);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          SettingsOptions(
            icon: const Icon(
              Icons.manage_accounts,
              color: Color(0xff7E8187),
            ),
            title: 'Manage Boats',
            onPressed: () {
              Navigator.pushNamed(context, ManageBoats.id);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          SettingsOptions(
              icon: const Icon(
                Icons.logout,
                color: const Color(0xff7E8187),
              ),
              title: 'Log Out',
              onPressed: () {
                Authentication().signOut().then((value) =>
                    Navigator.popAndPushNamed(context, SplashScreen.id));
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.53,
          ),
          ElevatedButton(
            onPressed: () {
              Authentication().deleteUserAccount().then(
                  (value) => Navigator.pushNamed(context, SplashScreen.id));
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red.shade700)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Delete Account",
                      style: GoogleFonts.lexendDeca(
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsOptions extends StatelessWidget {
  const SettingsOptions({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final Icon icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(children: [
            const SizedBox(
              width: 10,
            ),
            icon,
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: menuTextStyle,
            )
          ]),
        ),
      ),
    );
  }
}
