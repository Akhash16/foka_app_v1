import 'dart:convert';

import 'package:foka_app_v1/utils/authentication.dart';
import 'package:http/http.dart' as http;

class ApiCalls {
  final String _apiUrl = 'http://3c2e-183-82-207-1.ngrok.io/';

  List<dynamic> boats = [];

  List<String> imageUrl = [
    'https://i.pinimg.com/550x/a7/f5/90/a7f5904f50f65424dbfb69f18e8f7753.jpg',
    'https://www.viewbug.com/media/mediafiles/2019/05/27/84896105_large.jpg',
    'https://i.pinimg.com/736x/b3/df/17/b3df17c88af0b6e56988d42cb2c35e63.jpg',
  ];

  Future getBoatsApi(String email) async {
    Uri url = Uri.parse(_apiUrl + 'boatData?user=' + email);
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
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return boats;
  }

  void addBoatsApi(String hubId, String boatName, String otp) async {
    String email = Authentication().getCurrentUserEmail() as String;
    Uri url = Uri.parse(_apiUrl + 'boatData');
    http.Response response = await http.post(url, body: {
      "hubid": hubId,
      "boatname": boatName,
      "user": email,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void sample() async {
    var url = Uri.parse('http://54ae-183-82-204-6.ngrok.io/hubConnectionManager?hubid=DEMOHUB001');
    var response = await http.get(url);
    print(response.body);
  }
}
