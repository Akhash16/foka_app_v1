import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/make_sure.dart';
import 'package:foka_app_v1/screens/splash_screen.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);
  static const String id = "qr_code";

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  bool isVisible = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                hubId: "DEMOHUB0001",
                boatName: "My Boat 1",
              ),
            ),
            ModalRoute.withName(HomeScreen.id),
          );
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(
          //     builder: (context) => HomeScreen(
          //       hubId: "DEMOHUB0001",
          //       boatName: "My Boat 1",
          //     ),
          //   ),
          //   (Route<dynamic> route) => route == ModalRoute.withName(BoatsPage.id),
          // );
        },
      ),
      backgroundColor: const Color(0xff090f13),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              overlay: QrScannerOverlayShape(
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
                borderWidth: 10,
                borderLength: 20,
                borderRadius: 10,
              ),
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                      style: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      'Scan QR code',
                      style: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      dynamic data = jsonDecode(result!.code!);
      ApiCalls().addHub(data['ssid'].toString(), data['password'].toString()).then((value) {
        if (value) {
          Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.id));
        } else {
          print("post failed");
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
