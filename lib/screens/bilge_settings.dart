import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';

class BilgeSettingsPage extends StatefulWidget {
  // const BilgeSettingsPage({ Key? key }) : super(key: key);
  BilgeSettingsPage({this.settings});

  final dynamic settings;

  static const String id = 'bilge_settings_page';

  @override
  _BilgeSettingsPageState createState() => _BilgeSettingsPageState();
}

class _BilgeSettingsPageState extends State<BilgeSettingsPage> {
  dynamic settings = [];

  late String deviceName;

  late bool bilgeState;

  @override
  void initState() {
    super.initState();
    getSettings();
    deviceName = settings['serial'];
    bilgeState = settings['alert_bilge'] == 1 ? true : false;
  }

  void getSettings() {
    settings = widget.settings;
  }

  settingsUpdate() {
    ApiCalls().updateBilgeSettingsApi(deviceName, {
      "alert_fluid": bilgeState ? '1' : '0',
    });
  }

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
        title: const Text("Bilge Settings"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Bilge Settings',
              style: settingsHeadingTextStyle,
            ),
          ),
          ListTile(
            title: Text(
              'Enable Alerts',
              style: settingsLeadingTextStyle,
            ),
            trailing: Switch(
              value: bilgeState,
              onChanged: (value) {
                setState(() {
                  bilgeState = value;
                  settingsUpdate();
                });
              },
              inactiveTrackColor: Colors.white,
              inactiveThumbColor: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
