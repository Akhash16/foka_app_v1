import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/location_tracker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripLog extends StatefulWidget {
  const TripLog({Key? key}) : super(key: key);
  static const String id = "triplog_screen";

  @override
  State<TripLog> createState() => _TripLogState();
}

class _TripLogState extends State<TripLog> {
  double lat = 59.9139;
  double long = 10.7522;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> _points = const <LatLng>[
    LatLng(59.9139, 10.7522),
    LatLng(60.7938092, 11.0648129),
    LatLng(60.8794447,11.4840513),
    LatLng(60.1934581,11.9463607),
    LatLng(59.9139, 10.7522),
  ];

  List<PatternItem> _patterns = <PatternItem>[PatternItem.dot];

  final Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor mapMarker;
  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(5, 5)), "assets/location.png");
  }

  @override
  void initState() {
    super.initState();
    setCustomMarker();
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
          'Trip log',
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
      body: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        polylines: _polylines,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          zoom: 14,
        ),
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
                  title: "temp name 1",
                  snippet: "$lat,$long",
                ),
              ),
            );
            _polylines.add(
              Polyline(
                  polylineId: PolylineId("id_1"),
                  color: Colors.red,
                  points: _points,
                  width: 4,
                 
                  patterns: _patterns),
            );
          });
        },
      ),
    );
  }
}
