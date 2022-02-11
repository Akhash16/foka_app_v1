import 'dart:convert';

import 'package:foka_app_v1/utils/authentication.dart';
import 'package:http/http.dart' as http;

class ApiCalls {
  final String _apiUrl = 'https://b6ec-183-82-178-36.ngrok.io';
  final String _ip = 'http://192.168.4.1';

  List<dynamic> boats = [];

  List<String> imageUrl = [
    'https://i.pinimg.com/550x/a7/f5/90/a7f5904f50f65424dbfb69f18e8f7753.jpg',
    'https://www.viewbug.com/media/mediafiles/2019/05/27/84896105_large.jpg',
    'https://i.pinimg.com/736x/b3/df/17/b3df17c88af0b6e56988d42cb2c35e63.jpg',
  ];

  Future getBoatsApi(String email) async {
    Uri url = Uri.parse(_apiUrl + '/boatData?user=' + email);
    // password abcdefg
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var decodedData = jsonResponse['data'];
      for (int i = 0; i < decodedData.length; i++) {
        boats.add({
          'title': decodedData[i]['boatname'],
          'image': imageUrl[i % imageUrl.length],
          'description': 'Tap to continue to ' + decodedData[i]['boatname'],
          'hubid': decodedData[i]['hubid'],
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return boats;
  }

  void addBoatsApi(String hubId, String boatName, String otp) async {
    String email = Authentication().getCurrentUserEmail() as String;
    Uri url = Uri.parse(_apiUrl + '/boatData');
    http.Response response = await http.post(url, body: {
      "hubid": hubId,
      "boatname": boatName,
      "user": email,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<dynamic> getTHSSettingsApi(String deviceName) async {
    Uri url = Uri.parse(_apiUrl + "/settingsManager/THS?serial=" + deviceName);
    print(url);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    print(response.body);
    var decodedData = jsonResponse['data'];
    print(decodedData);
    return decodedData[0];
  }

  void updateTHSSettingsApi(String deviceName, dynamic settings) async {
    Uri url = Uri.parse(_apiUrl + "/settingsManager/THS/" + deviceName);
    http.Response response = await http.put(url, body: settings);
    //   if (response.statusCode == 200) {
    //     return Future<bool>.value(true);
    //   }
    //   return Future<bool>.value(false);
  }

  Future<dynamic> getUltrasonicSettingsApi(String deviceName) async {
    Uri url = Uri.parse(_apiUrl + "/settingsManager/Ultrasonic?serial=" + deviceName);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    var decodedData = jsonResponse['data'];
    return decodedData[0];
  }

  void updateUltrasonicSettingsApi(String deviceName, dynamic settings) async {
    Uri url = Uri.parse(_apiUrl + "/settingsManager/Ultrasonic/" + deviceName);
    http.Response response = await http.put(url, body: settings);
    // if (response.statusCode == 200) {
    //   return Future<bool>.value(true);
    // }
    // return Future<bool>.value(false);
  }

  Future<dynamic> getBilgeSettingsApi(String deviceName) async {
    Uri url = Uri.parse(_apiUrl + "/settingsManager/Ultrasonic?serial=" + deviceName);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    var decodedData = jsonResponse['data'];
    return decodedData[0];
  }

  void updateBilgeSettingsApi(String deviceName, dynamic settings) async {
    Uri url = Uri.parse(_apiUrl + "/settingsManager/Ultrasonic/" + deviceName);
    http.Response response = await http.put(url, body: settings);
    // if (response.statusCode == 200) {
    //   return Future<bool>.value(true);
    // }
    // return Future<bool>.value(false);
  }

  Future<dynamic> getSmartConnectSettingsApi(String deviceName) async {
    Uri url = Uri.parse(_apiUrl + "/settingsManager/SmartConnect?serial=" + deviceName);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    var decodedData = jsonResponse['data'];
    return decodedData[0];
  }

  void updateSmartConnectSettingsApi(String deviceName, dynamic settings) async {
    Uri url = Uri.parse(_apiUrl + '/settingsManager/SmartConnect/' + deviceName);
    http.Response response = await http.put(url, body: settings);
    print(settings);
    print(response.statusCode);
  }

  Future<dynamic> getLocationSettingsApi(String deviceName) async {
    Uri url = Uri.parse(_apiUrl + "/settingsManager/Location?serial=" + deviceName);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    var decodedData = jsonResponse['data'];
    print(decodedData);
    return decodedData[0];
  }

  void updateLocationSettingsApi(String deviceName, dynamic settings) async {
    Uri url = Uri.parse(_apiUrl + '/settingsManager/Location/' + deviceName);
    http.Response response = await http.put(url, body: settings);
    print(response.statusCode);
  }

  Future<List> getHubDevices(String hubId) async {
    Uri url = Uri.parse(_apiUrl + "/deviceSyncManager?hubid=" + hubId);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    List<dynamic> hubDevices = [
      jsonResponse['THS'],
      jsonResponse['US'],
      jsonResponse['FLT'],
      jsonResponse['SC'],
      jsonResponse['LT'],
      jsonResponse['SE'],
    ];
    return Future<List>.value(hubDevices);
  }

  Future<List> getConnectedDevices(String hubId) async {
    Uri url = Uri.parse(_apiUrl + "/hubConnectionManager?hubid=" + hubId);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    List<dynamic> connectedDevices = [
      jsonResponse['THS'],
      jsonResponse['US'],
      jsonResponse['FLT'],
      jsonResponse['SC'],
      jsonResponse['LT'],
      jsonResponse['SE'],
    ];
    return Future<List>.value(connectedDevices);
  }

  Future<List> getConnectedDevicesCount(String hubId) async {
    Uri url = Uri.parse(_apiUrl + "/hubConnectionManager?hubid=" + hubId);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    List<int> connectedDevices = [
      jsonResponse['THS'].length,
      jsonResponse['US'].length,
      jsonResponse['FLT'].length,
      jsonResponse['SC'].length,
      jsonResponse['LT'].length,
      jsonResponse['SE'].length,
    ];
    return Future<List>.value(connectedDevices);
  }

  Future<List> getHubDevicesCount(String hubId) async {
    Uri url = Uri.parse(_apiUrl + "/deviceSyncManager?hubid=" + hubId);
    http.Response response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);
    List<int> hubDevices = [
      jsonResponse['THS'].length,
      jsonResponse['US'].length,
      jsonResponse['FLT'].length,
      jsonResponse['SC'].length,
      jsonResponse['LT'].length,
      jsonResponse['SE'].length,
    ];
    return Future<List>.value(hubDevices);
  }

  Future<bool> addHub(String ssid, String password) async {
    Uri url = Uri.parse(_ip + '/');
    http.Response response = await http.post(url, body: {
      "ssid": ssid,
      "password": password,
    });
    if (response.statusCode == 200) {
      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  }

  void sample() async {
    var url = Uri.parse('http://54ae-183-82-204-6.ngrok.io/hubConnectionManager?hubid=DEMOHUB001');
    var response = await http.get(url);
    print(response.body);
  }
}
