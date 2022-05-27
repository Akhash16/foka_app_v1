import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/utils/apiCalls.dart';
import 'package:foka_app_v1/utils/authentication.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class AddDeviceName extends StatefulWidget {
  const AddDeviceName({Key? key}) : super(key: key);

  static const String id = 'add_device_name';

  @override
  State<AddDeviceName> createState() => _AddDeviceNameState();
}

class _AddDeviceNameState extends State<AddDeviceName> {
  bool showSpinner = false;

  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("hubId set ${Data.getHubId()}");
    return Scaffold(
      backgroundColor: const Color(0xff1A1E20),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  'Device Name',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 700),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  child: TextField(
                    controller: textController,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      hintText: 'Enter Device Name',
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.white24,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 900),
                child: ConfirmationSlider(
                  onConfirmation: () async {
                    if (textController.text != '') {
                      ApiCalls.addDeviceApi(Data.getHubId(), Data.getDeviceId(), textController.text, Data.getDeviceType()).then((value) => Navigator.popAndPushNamed(context, HomeScreen.id));
                      // await ApiCalls.getHubDevices(Data.getHubId()).then(
                      //   (value) {
                      //     Data.setDevices(value);
                      //     Navigator.popAndPushNamed(context, BoatsPage.id);
                      //   },
                      // );
                      // Navigator.popAndPushNamed(context, HomeScreen.id);
                    }
                  },
                  height: 60,
                  width: 260,
                  sliderButtonContent: const Icon(Icons.chevron_right, color: Colors.white, size: 30),
                  backgroundColor: Colors.white12,
                  textStyle: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
