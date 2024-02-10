import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/location_tracker.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoFence extends StatefulWidget {
  // const GeoFence({Key? key}) : super(key: key);
  GeoFence({this.lat, this.long, this.settings});

  final lat, long, settings;

  static const String id = "geofence";

  @override
  _GeoFenceState createState() => _GeoFenceState();
}

class _GeoFenceState extends State<GeoFence> {
  late double lat;
  late double long;
  late double _radiusValue = 100;
  late LatLng currentLocation;
  dynamic settings;
  late String deviceId;
  late bool isGeofence = false;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  final Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor mapMarker;
  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "assets/location.png");
  }

  @override
  void initState() {
    getSettings();
    print(widget.lat);
    print(widget.long);
    lat = widget.lat;
    long = widget.long;
    currentLocation = LatLng(lat, long);
    super.initState();
    setCustomMarker();
  }

  void getSettings() {
    settings = widget.settings;
    setState(() {
      deviceId = settings['serial'];
      _radiusValue = settings['radius'].toDouble();
      isGeofence = settings['geofence_enable'] == 1;
      print("${deviceId} ${_radiusValue} ${isGeofence}");
      print("setstate done");
    });
  }

  void setSettings() {
    print('$lat $long $isGeofence $_radiusValue');
    ApiCalls.updateLocationSettingsApi(deviceId, {
      "dock_point": "$lat,$long",
      "geofence_enable": isGeofence ? '1' : '0',
      "radius": _radiusValue.toString(),
    });
  }

  _handleTap(LatLng tappedLocation) {
    setState(() {
      currentLocation = tappedLocation;

      _markers.clear();
      _markers.add(Marker(
        visible: true,
        icon: mapMarker,
        markerId: MarkerId(
          tappedLocation.toString(),
        ),
        position: tappedLocation,
        infoWindow: InfoWindow(
          title: "Coordinates",
          snippet: "$tappedLocation",
        ),
      ));

      _circles.add(
        Circle(
          circleId: const CircleId('id-1'),
          radius: _radiusValue,
          center: tappedLocation,
          fillColor: Colors.blue.shade200,
          strokeColor: Colors.blue,
          strokeWidth: 3,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context, LocationScreen.id);
          },
        ),
        title: const Text(
          'Add Geofence',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: GoogleMap(
              markers: _markers,
              circles: _circles,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 15,
              ),
              onTap: _handleTap,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                setState(() {
                  _markers.add(
                    Marker(
                      icon: mapMarker,
                      visible: true,
                      markerId: const MarkerId('id-1'),
                      position: LatLng(lat, long),
                      infoWindow: InfoWindow(
                        title: "Coordinates",
                        snippet: "$lat,$long",
                      ),
                    ),
                  );
                  _circles.add(
                    Circle(
                      circleId: const CircleId('id-1'),
                      radius: _radiusValue,
                      center: LatLng(lat, long),
                      fillColor: Colors.blue.shade200,
                      strokeColor: Colors.blue,
                      strokeWidth: 3,
                    ),
                  );
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xff090f13),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Enable Alerts",
                            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Switch(
                            value: isGeofence,
                            inactiveTrackColor: Colors.white,
                            inactiveThumbColor: Colors.blueGrey,
                            onChanged: (value) {
                              setState(() {
                                isGeofence = value;
                              });
                              setSettings();
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slider(
                          divisions: 500,
                          thumbColor: Colors.white,
                          activeColor: Colors.teal.shade300,
                          inactiveColor: Colors.grey,
                          value: _radiusValue,
                          min: 0,
                          max: 500,
                          label: "$_radiusValue",
                          onChanged: (double value) {
                            setState(() {
                              _radiusValue = value;
                              _circles.clear();
                              _circles.add(
                                Circle(
                                  circleId: const CircleId('id-1'),
                                  radius: _radiusValue,
                                  center: currentLocation,
                                  fillColor: Colors.blue.shade200,
                                  strokeColor: Colors.blue,
                                  strokeWidth: 3,
                                ),
                              );
                            });
                          },
                        ),
                      ),
                      Text(
                        "Radius : $_radiusValue",
                        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      RoundedButton(
                        title: "Set Current location as Dock location",
                        color: Colors.teal.shade400,
                        onPressed: () {
                          print(lat);
                          print(long);
                          print(_radiusValue);

                          setSettings();
                        },
                      ),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
              ),
            ),
          )
        ],
      ),
    );
  }
}
