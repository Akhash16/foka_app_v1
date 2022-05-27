import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/add_boat_verification.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:animate_do/animate_do.dart';

class AddBoatScreen extends StatefulWidget {
  const AddBoatScreen({Key? key}) : super(key: key);

  static const String id = 'add_boat_screen';

  @override
  State<AddBoatScreen> createState() => _AddBoatScreenState();
}

class _AddBoatScreenState extends State<AddBoatScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  var data;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print("inside scanned data");
      setState(() {
        result = scanData;
      });
      print("set state done");
      data = jsonDecode(result!.code!);
      print("printing data" + data['hubId'].toString());
      Data.setHubId(data['hubId']);
      print("hubid set");
      Navigator.popAndPushNamed(context, AddBoatVerification.id);
      // ApiCalls.addHub(data['ssid'].toString(), data['password'].toString()).then((value) {
      //   if (value) {
      //     Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.id));
      //   } else {
      //     print("post failed");
      //   }
      // });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1A1E20).withOpacity(1),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddBoatVerification.id),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            overlay: QrScannerOverlayShape(
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
              borderWidth: 10,
              borderLength: 20,
              borderRadius: 10,
            ),
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          (result != null)
              ? Text(
                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                  style: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
                )
              : Text(
                  'Scan QR code',
                  style: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
                ),
        ],
      ),
    );
  }
}
