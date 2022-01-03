import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class THSSettingsPage extends StatefulWidget {
  const THSSettingsPage({Key? key}) : super(key: key);

  static const String id = 'ths_settings_page';

  @override
  _THSSettingsPageState createState() => _THSSettingsPageState();
}

class _THSSettingsPageState extends State<THSSettingsPage> {
  bool state = false;
  int _currentLowerValue = 10;
  int _currentUpperValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090f13),
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("THS Settings"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, THSSettingsPage.id);
        //     },
        //     icon: const Icon(Icons.settings),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Enable Alerts',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Switch(
                        value: state,
                        onChanged: (value) {
                          setState(() {
                            state = value;
                          });
                        },
                        inactiveTrackColor: Colors.white,
                        inactiveThumbColor: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Lower Limit',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: NumberPicker(
                      minValue: -20,
                      maxValue: 60,
                      value: _currentLowerValue,
                      onChanged: (value) {
                        setState(() {
                          _currentLowerValue = value;
                        });
                      },
                      textStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Upper Limit',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: NumberPicker(
                      minValue: -20,
                      maxValue: 60,
                      value: _currentUpperValue,
                      onChanged: (value) {
                        setState(() {
                          _currentUpperValue = value;
                        });
                      },
                      textStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            RoundedButton(
              title: 'Refresh',
              color: Colors.lightBlueAccent,
              onPressed: () {},
              width: MediaQuery.of(context).size.width * 0.7,
            )
          ],
        ),
      ),
    );
  }
}
