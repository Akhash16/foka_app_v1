import "package:flutter/material.dart";
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/screens/manage_boats_screen.dart';
import 'package:foka_app_v1/screens/profile_screen.dart';
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
              // Navigator.pushNamed(context, THSSettingsPage.id);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
      const SizedBox(height: 20,),
      InkWell(
        onTap: (() {
           Navigator.pushNamed(context, ProfileScreen.id);
        }),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(children: [
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.edit,
                color: Color(0xff7E8187),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Edit Profile",
                style: menuTextStyle,
              )
            ]),
          ),
        ),
      ),
      const SizedBox(height: 20,),
      InkWell(
         onTap: (() {
          Navigator.pushNamed(context, ManageBoats.id);
        }),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.manage_accounts,
                  color: Color(0xff7E8187),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Manage Boats",
                  style: menuTextStyle,
                )
              ]),
            ),
          ),
        ),
      ),
      const SizedBox(height: 20,),
      InkWell(
        onTap: () {
          
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.logout,
                  color: const Color(0xff7E8187),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Log Out",
                  style: menuTextStyle,
                )
              ]),
            ),
          ),
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height*0.53,),
      ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade700)),
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
      const SizedBox(width: 10,),
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
