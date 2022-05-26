import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:foka_app_v1/components/constants.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';

class THSSettingsPage extends StatefulWidget {
  // const THSSettingsPage({Key? key}) : super(key: key);
  THSSettingsPage({this.settings});

  final dynamic settings;

  static const String id = 'ths_settings_page';

  @override
  _THSSettingsPageState createState() => _THSSettingsPageState();
}

class _THSSettingsPageState extends State<THSSettingsPage> {
  dynamic settings = [];

  late String deviceName;

  late bool tempState;
  late int tempCurrentLowerValue;
  late int tempCurrentUpperValue;

  late bool gasState;
  int gasCurrentLowerValue = 0; // removed in front end.. dont pu
  late int gasCurrentUpperValue;

  late bool humidityState;
  late int humidityCurrentLowerValue;
  late int humidityCurrentUpperValue;

  late var previousValue;

  @override
  void initState() {
    super.initState();
    getSettings();
    deviceName = settings['serial'];
    tempState = settings['alert_temp'] == 1 ? true : false;
    tempCurrentLowerValue = settings['low_temp'];
    tempCurrentUpperValue = settings['high_temp'];
    gasState = settings['alert_gas'] == 1 ? true : false;
    gasCurrentUpperValue = settings['high_gas'];
    humidityState = settings['alert_humidity'] == 1 ? true : false;
    humidityCurrentLowerValue = settings['low_hum'];
    humidityCurrentUpperValue = settings['high_hum'];
  }

  void getSettings() {
    settings = widget.settings;
  }

  settingsUpdate() {
    ApiCalls.updateTHSSettingsApi(deviceName, {
      "alert_temp": tempState ? '1' : '0',
      "low_temp": tempCurrentLowerValue.toString(),
      "high_temp": tempCurrentUpperValue.toString(),
      "alert_gas": gasState ? '1' : '0',
      "high_gas": gasCurrentUpperValue.toString(),
      "alert_hum": humidityState ? '1' : '0',
      "low_hum": humidityCurrentLowerValue.toString(),
      "high_hum": humidityCurrentUpperValue.toString(),
    });
  }

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
          var selectedValue = picker.getSelectedValues()[0];
          previousValue = settings['temp_lower'];
          setState(() {
            isUpperLimit
                ? tempCurrentLowerValue <= selectedValue
                    ? tempCurrentUpperValue = selectedValue
                    : null
                : tempCurrentUpperValue >= selectedValue
                    ? tempCurrentLowerValue = selectedValue
                    : null;
            // settingsUpdate() ? null : tempCurrentLowerValue = previousValue;
            settingsUpdate();
          });
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
          settingsUpdate();
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
                      settingsUpdate();
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
                      settingsUpdate();
                    });
                  },
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.blueGrey,
                ),
              ),
              // ListTile(
              //   onTap: () => showPickerNumberGas(context, false),
              //   leading: Text(
              //     'Lower Limit',
              //     style: settingsLeadingTextStyle,
              //   ),
              //   title: Text(
              //     gasCurrentLowerValue.toString(),
              //     style: settingsTitleTextStyle,
              //     textAlign: TextAlign.end,
              //   ),
              //   trailing: settingsTrailingIcon,
              // ),
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
                      settingsUpdate();
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
