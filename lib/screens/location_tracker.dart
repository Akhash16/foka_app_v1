import 'dart:async';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_screen.dart';

var lat = 13.0201638;
var long = 80.2217002;
var zoom = 20.83;

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);
  static const id = "location_screen";

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List dropdownItemList = [
    {'label': 'Location Tracker 1', 'value': '1'},
    {'label': 'Location Tracker 2', 'value': '2'},
    {'label': 'Location Tracker 3', 'value': '3'},
    {'label': 'Location Tracker 4', 'value': '4'}, // label is required and unique
    {'label': 'Location Tracker 5', 'value': '5'},
    {'label': 'Location Tracker 6', 'value': '6'},
    {'label': 'Location Tracker 7', 'value': '7'}
    ];
   Completer<GoogleMapController> _controller = Completer();

   CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(lat, long),
    zoom: 14,
  );

 CameraPosition kBoat = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(lat, long),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context, HomeScreen.id);
          },
        ),
        title: CoolDropdown(
          resultWidth: 220,
          dropdownItemAlign: Alignment.center,
          resultAlign: Alignment.center,
          dropdownBD: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          selectedItemBD: BoxDecoration(
            color: const Color(0xff090f13),
            borderRadius: BorderRadius.circular(10),
          ),
          selectedItemTS: const TextStyle(color: const Color(0xFF6FCC76), fontSize: 20),
          unselectedItemTS: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          resultBD: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff090f13),
          ),
          resultTS: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),

          isTriangle: false,
          dropdownList: dropdownItemList,
          onChange: (_)  {
            
          },
          defaultValue: dropdownItemList[0],
          // placeholder: 'insert...',
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
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(
            8, 8, MediaQuery.of(context).size.width * 0.3, 8),
        child: FloatingActionButton.extended(
          elevation: 9,
          onPressed: _goToTheBoat,
          label: const Text('locate'),
          icon: const Icon(Icons.location_on),
        ),
      ),
    );
  }

  Future<void> _goToTheBoat() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kBoat));
  }
}
