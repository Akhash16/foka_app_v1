import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';

class FluidSettingsPage extends StatefulWidget {
  // const FluidSettingsPage({Key? key}) : super(key: key);
  FluidSettingsPage({this.settings, this.value});

  final dynamic settings;
  final value;

  static const String id = 'fluid_settings_page';

  @override
  _FluidSettingsPageState createState() => _FluidSettingsPageState();
}

class _FluidSettingsPageState extends State<FluidSettingsPage> {
  dynamic settings = [];

  late String deviceName;

  late bool fluidState;
  bool bilgeState = false; // dont put
  late int currentLowerValue;
  int currentUpperValue = 100; //dont put

  @override
  void initState() {
    super.initState();
    getSettings();
    deviceName = settings['serial'];
    fluidState = settings['alert_fluid'] == 1 ? true : false;
    currentLowerValue = settings['low_tank'];
  }

  void getSettings() {
    settings = widget.settings;
  }

  settingsUpdate() {
    ApiCalls().updateUltrasonicSettingsApi(deviceName, {
      "alert_fluid": fluidState ? '1' : '0',
      "low_tank": currentLowerValue.toString(),
    });
  }

  showPickerNumber(BuildContext context, bool isUpperLimit) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          const NumberPickerColumn(begin: 0, end: 100),
        ]),
        hideHeader: true,
        title: const Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int selectedValue = picker.getSelectedValues()[0] as int;
          setState(() {
            isUpperLimit
                ? currentLowerValue <= selectedValue
                    ? currentUpperValue = selectedValue
                    : null
                : currentUpperValue >= selectedValue
                    ? currentLowerValue = selectedValue
                    : null;
          });
          settingsUpdate();
        }).showDialog(context);
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
        title: const Text("Fluid Monitor Settings"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Fluid Monitor Settings',
                style: settingsHeadingTextStyle,
              ),
            ),
            ListTile(
              title: Text(
                'Enable Alerts',
                style: settingsLeadingTextStyle,
              ),
              trailing: Switch(
                value: fluidState,
                onChanged: (value) {
                  setState(() {
                    fluidState = value;
                    settingsUpdate();
                  });
                },
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.blueGrey,
              ),
            ),
            ListTile(
              onTap: () => showPickerNumber(context, false),
              leading: Text(
                'Lower Limit',
                style: settingsLeadingTextStyle,
              ),
              title: Text(
                currentLowerValue.toString(),
                style: settingsTitleTextStyle,
                textAlign: TextAlign.end,
              ),
              trailing: settingsTrailingIcon,
            ),
            // ListTile(
            //   onTap: () => showPickerNumber(context, true),
            //   leading: Text(
            //     'Upper Limit',
            //     style: settingsLeadingTextStyle,
            //   ),
            //   title: Text(
            //     currentUpperValue.toString(),
            //     style: settingsTitleTextStyle,
            //     textAlign: TextAlign.end,
            //   ),
            //   trailing: settingsTrailingIcon,
            // ),
            // settingsPageDivider,
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Text(
            //     'Bilge Settings',
            //     style: settingsHeadingTextStyle,
            //   ),
            // ),
            // ListTile(
            //   title: Text(
            //     'Enable Alerts',
            //     style: settingsLeadingTextStyle,
            //   ),
            //   trailing: Switch(
            //     value: bilgeState,
            //     onChanged: (value) {
            //       setState(() {
            //         bilgeState = value;
            //         settingsUpdate();
            //       });
            //     },
            //     inactiveTrackColor: Colors.white,
            //     inactiveThumbColor: Colors.blueGrey,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
