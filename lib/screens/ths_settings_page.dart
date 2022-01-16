import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class THSSettingsPage extends StatefulWidget {
  const THSSettingsPage({Key? key}) : super(key: key);

  static const String id = 'ths_settings_page';

  @override
  _THSSettingsPageState createState() => _THSSettingsPageState();
}

class _THSSettingsPageState extends State<THSSettingsPage> {
  bool tempState = false;
  int tempCurrentLowerValue = 10;
  int tempCurrentUpperValue = 20;

  bool gasState = false;
  int gasCurrentLowerValue = 1000;
  int gasCurrentUpperValue = 4000;

  bool humidityState = false;
  int humidityCurrentLowerValue = 20;
  int humidityCurrentUpperValue = 80;

  showPickerNumberTemperature(BuildContext context, bool isUpperLimit) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          const NumberPickerColumn(begin: -50, end: 100),
        ]),
        hideHeader: true,
        itemExtent: 35.0,
        squeeze: 1,
        title: const Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int selectedValue = picker.getSelectedValues()[0] as int;
          setState(() {
            isUpperLimit
                ? tempCurrentLowerValue <= selectedValue
                    ? tempCurrentUpperValue = selectedValue
                    : null
                : tempCurrentUpperValue >= selectedValue
                    ? tempCurrentLowerValue = selectedValue
                    : null;
          });
          // print(value[0].toString());
        }).showDialog(context);
  }

  showPickerNumberGas(BuildContext context, bool isUpperLimit) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          const NumberPickerColumn(begin: 0, end: 10000, jump: 100),
        ]),
        hideHeader: true,
        itemExtent: 35.0,
        squeeze: 1,
        title: const Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int selectedValue = picker.getSelectedValues()[0] as int;
          setState(() {
            isUpperLimit
                ? gasCurrentLowerValue <= selectedValue
                    ? gasCurrentUpperValue = selectedValue
                    : null
                : gasCurrentUpperValue >= selectedValue
                    ? gasCurrentLowerValue = selectedValue
                    : null;
          });
          // print(value[0].toString());
        }).showDialog(context);
  }

  showPickerNumberHumidity(BuildContext context, bool isUpperLimit) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          const NumberPickerColumn(begin: 0, end: 100),
        ]),
        hideHeader: true,
        itemExtent: 35.0,
        squeeze: 1,
        title: const Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int selectedValue = picker.getSelectedValues()[0] as int;
          setState(() {
            isUpperLimit
                ? humidityCurrentLowerValue <= selectedValue
                    ? humidityCurrentUpperValue = selectedValue
                    : null
                : humidityCurrentUpperValue >= selectedValue
                    ? humidityCurrentLowerValue = selectedValue
                    : null;
          });
          // print(value[0].toString());
        }).showDialog(context);
  }

  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        title: const Text("Select Data"),
        selectedTextStyle: const TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
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
        title: const Text("THS Settings"),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Temperature Settings', style: settingsHeadingTextStyle),
              ListTile(
                title: Text(
                  'Enable Alerts',
                  style: settingsLeadingTextStyle,
                ),
                trailing: Switch(
                  value: tempState,
                  onChanged: (value) {
                    setState(() {
                      tempState = value;
                    });
                  },
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.blueGrey,
                ),
              ),
              ListTile(
                onTap: () => showPickerNumberTemperature(context, false),
                leading: Text(
                  'Lower Limit',
                  style: settingsLeadingTextStyle,
                ),
                title: Text(
                  tempCurrentLowerValue.toString(),
                  style: settingsTitleTextStyle,
                  textAlign: TextAlign.end,
                ),
                trailing: settingsTrailingIcon,
              ),
              ListTile(
                onTap: () => showPickerNumberTemperature(context, true),
                leading: Text(
                  'Upper Limit',
                  style: settingsLeadingTextStyle,
                ),
                title: Text(
                  tempCurrentUpperValue.toString(),
                  style: settingsTitleTextStyle,
                  textAlign: TextAlign.end,
                ),
                trailing: settingsTrailingIcon,
              ),
              settingsPageDivider,
              Text('Gas Settings', style: settingsHeadingTextStyle),
              ListTile(
                title: Text(
                  'Enable Alerts',
                  style: settingsLeadingTextStyle,
                ),
                trailing: Switch(
                  value: gasState,
                  onChanged: (value) {
                    setState(() {
                      gasState = value;
                    });
                  },
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.blueGrey,
                ),
              ),
              ListTile(
                onTap: () => showPickerNumberGas(context, false),
                leading: Text(
                  'Lower Limit',
                  style: settingsLeadingTextStyle,
                ),
                title: Text(
                  gasCurrentLowerValue.toString(),
                  style: settingsTitleTextStyle,
                  textAlign: TextAlign.end,
                ),
                trailing: settingsTrailingIcon,
              ),
              ListTile(
                onTap: () => showPickerNumberGas(context, true),
                leading: Text(
                  'Upper Limit',
                  style: settingsLeadingTextStyle,
                ),
                title: Text(
                  gasCurrentUpperValue.toString(),
                  style: settingsTitleTextStyle,
                  textAlign: TextAlign.end,
                ),
                trailing: settingsTrailingIcon,
              ),
              settingsPageDivider,
              Text(
                'Humidity Settings',
                style: settingsHeadingTextStyle,
              ),
              ListTile(
                title: Text(
                  'Enable Alerts',
                  style: settingsLeadingTextStyle,
                ),
                trailing: Switch(
                  value: humidityState,
                  onChanged: (value) {
                    setState(() {
                      humidityState = value;
                    });
                  },
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.blueGrey,
                ),
              ),
              ListTile(
                onTap: () => showPickerNumberHumidity(context, false),
                leading: Text(
                  'Lower Limit',
                  style: settingsLeadingTextStyle,
                ),
                title: Text(
                  humidityCurrentLowerValue.toString(),
                  style: settingsTitleTextStyle,
                  textAlign: TextAlign.end,
                ),
                trailing: settingsTrailingIcon,
              ),
              ListTile(
                onTap: () => showPickerNumberHumidity(context, true),
                leading: Text(
                  'Upper Limit',
                  style: settingsLeadingTextStyle,
                ),
                title: Text(
                  humidityCurrentUpperValue.toString(),
                  style: settingsTitleTextStyle,
                  textAlign: TextAlign.end,
                ),
                trailing: settingsTrailingIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
