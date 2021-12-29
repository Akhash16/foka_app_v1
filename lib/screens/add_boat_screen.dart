// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/boat_add_data.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class AddBoatScreen extends StatelessWidget {
  const AddBoatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController textController = TextEditingController();
    String boatIdField;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff1A1E20),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 48.0,
        ),
        child: ConfirmationSlider(
          onConfirmation: () {
            Navigator.pushNamed(context, BoatAddData.id);
          },
          text: 'Slide to Add Boat',
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          backgroundColor: Colors.black38,
          foregroundColor: Colors.white,
          sliderButtonContent: const Icon(
            Icons.chevron_right,
            color: Colors.black,
            size: 35,
          ),
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        //     const Text(
        //       'Add Boat',
        //       style: TextStyle(
        //         fontSize: 30.0,
        //         color: Colors.white,
        //       ),
        //     ),
        //     SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        //     Image.network("https://cdn.discordapp.com/attachments/867367813047779338/921427885888249876/117-1176532_yacht-png-transparent-yacht-side-view-png-png-removebg-preview.png"),
        //     SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        //     const Text(
        //       'Boat Id',
        //       style: TextStyle(
        //         fontSize: 25.0,
        //         color: Colors.white54,
        //       ),
        //     ),
        //     SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        //     TextField(
        //       onChanged: (newText) {
        //         boatIdField = newText;
        //       },
        //       textAlign: TextAlign.center,
        //       style: const TextStyle(
        //         color: Colors.white,
        //       ),
        //       decoration: const InputDecoration(
        //         contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        //         hintText: 'Enter Hub Id',
        //         hintStyle: TextStyle(
        //           color: Colors.white54,
        //         ),
        //       ),
        //     ),
        //     SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        //   ],
        // ),
      ),
    );
  }
}
