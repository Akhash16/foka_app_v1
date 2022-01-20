import 'dart:async';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'home_screen.dart';
import 'package:easy_geofencing/easy_geofencing.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);
  static const id = "location_screen";

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  String geofenceStatus = "";
  late BitmapDescriptor mapMarker;
  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(5, 5)), "assets/location.png");
  }

  // double lat = 13.0201638, long = 80.2217002, zoom = 20.83;
  //59.9139, 10.7522
  double lat = 59.9139;
  double long = 10.7522;
  List<String> parts = ['59.9139', '10.7522'];

  late MqttServerClient client;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    setCustomMarker();
    Timer timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => change());

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
    _markers.clear();
    _markers.add(
      Marker(
        icon: mapMarker,
        visible: true,
        markerId: const MarkerId('id-1'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
          title: "Co-ordinates",
          snippet: "$lat,$long",
        ),
      ),
    );
    

    _goToTheBoat();
    setCustomMarker();
  }

  Future<void> _goToTheBoat() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(lat, long),
          // tilt: 59.440717697143555,
          zoom: 14,
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
        title: const Text(
          "Location Tracker",
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
        circles: _circles,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          // zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _circles.add(
              Circle(
                circleId: const CircleId('id-1'),
                radius: 100,
                center: LatLng(lat, long),
                fillColor: Colors.blue.shade200,
                strokeColor: Colors.blue,
                strokeWidth: 3,
              ),
            );
            _markers.add(
              Marker(
                icon: mapMarker,
                visible: true,
                markerId: const MarkerId('id-1'),
                position: LatLng(lat, long),
                infoWindow: InfoWindow(
                  title: "Boat Name",
                  snippet: "$lat,$long",
                ),
              ),
            );
          });
          EasyGeofencing.startGeofenceService(
            pointedLatitude: '$lat',
            pointedLongitude: '$long',
            radiusMeter: '100',
            eventPeriodInSeconds: 5,
          );
          StreamSubscription<GeofenceStatus> geofenceStatusStream =
        EasyGeofencing.getGeofenceStream()!.listen((GeofenceStatus status) {
      print("The geofence status is : " + status.toString());
      geofenceStatus = status.toString();
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
