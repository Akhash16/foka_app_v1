import 'dart:async';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'home_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);
  static const id = "location_screen";

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Set<Marker> _markers = {};
  late BitmapDescriptor mapMarker;
  void setCustomMarker() async {
      mapMarker = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(5, 5)), "assets/location.png");
  }
  List dropdownItemList = [
    {'label': 'Location Tracker 1', 'value': '1'},
    {'label': 'Location Tracker 2', 'value': '2'},
    {'label': 'Location Tracker 3', 'value': '3'},
    {
      'label': 'Location Tracker 4',
      'value': '4'
    }, // label is required and unique
    {'label': 'Location Tracker 5', 'value': '5'},
    {'label': 'Location Tracker 6', 'value': '6'},
    {'label': 'Location Tracker 7', 'value': '7'}
  ];

  // double lat = 13.0201638, long = 80.2217002, zoom = 20.83;
  double lat = 0;
  double long = 0;
  double zoom = 19.83;
  List<String> parts = ['0.0', '0.0'];

  late MqttServerClient client;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    setCustomMarker();
    Timer timer =
        Timer.periodic(const Duration(seconds: 10), (Timer t) => change());

    void start() async {
      await connectClient();
      client.subscribe("/DEMOHUB001/FKB001LT", MqttQos.atLeastOnce);
    }

    start();
  }

  Future<MqttServerClient> connectClient() async {
    print('connect started');
    client = MqttServerClient.withPort('164.52.212.96', MyApp.clientId, 1883);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 20;

    print('final con');
    final connMessage = MqttConnectMessage()
        .authenticateAs('admin', 'smartboat@rec&adr')
        // ignore: deprecated_member_use
        .withClientIdentifier(MyApp.clientId)
        .keepAliveFor(6000)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    print('try');
    try {
      await client.connect();
    } catch (e) {
      print('catch');
      print('Exception: $e');
      client.disconnect();
    }

    print('try done');
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}>');

      parts = payload.split(',');
      print("message_received : $parts");
    });

    // client.subscribe("/DEMOHUB001/FKB001THS", MqttQos.atLeastOnce);

    return client;
  }

  // connection succeeded
  void onConnected() {
    print('Connected');
  }

// unconnected
  void onDisconnected() {
    print('Disconnected');
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String? topic) {
    print('Unsubscribed topic: $topic');
  }

// PING response received
  void pong() {
    print('Ping response client callback invoked');
  }

  void change() {
    setState(() {
      lat = double.parse(parts[0]);
      long = double.parse(parts[1]);
    });
    _goToTheBoat();
  }

  Future<void> _goToTheBoat() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat, long),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414,
        ),
      ),
    );
  }

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
          selectedItemTS:
              const TextStyle(color: Color(0xFF6FCC76), fontSize: 20),
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
          onChange: (_) {},
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
        markers: _markers,
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
                markerId: const MarkerId('coordinates'),
                position: LatLng(lat, long),
                infoWindow: InfoWindow(
                  title: "Co-ordinates",
                  snippet: "$lat,$long",
                ),
              ),
            );
          });
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
          backgroundColor: const Color(0xff090f13).withOpacity(0.8),
        ),
      ),
    );
  }
}
