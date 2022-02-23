import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/security_monitor.dart';
import 'package:google_fonts/google_fonts.dart';

class SnapsScreen extends StatefulWidget {
  const SnapsScreen({Key? key}) : super(key: key);
  static const id = "snaps_screen";

  @override
  _SnapsScreenState createState() => _SnapsScreenState();
}

class _SnapsScreenState extends State<SnapsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> snaps = [
      const SnapWidget(
        imgUrl: 'https://picsum.photos/500/500?random=1',
        text: 'hello',
      ),
      const SnapWidget(
        imgUrl: 'https://picsum.photos/500/500?random=2',
        text: 'hello',
      ),
      const SnapWidget(
        imgUrl: 'https://picsum.photos/500/500?random=3',
        text: 'hello',
      ),
      const SnapWidget(
        imgUrl: 'https://picsum.photos/500/500?random=4',
        text: 'hello',
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xff090f13),
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context, SecurityScreen.id);
          },
        ),
        title: const Text(
          'Snaps',
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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: AppinioSwiper(
          onEnd: () {
            print("reached the end");
            setState(() {});
          },
          cards: snaps,
        ),
      ),
    );
  }
}

class SnapWidget extends StatelessWidget {
  final String text, imgUrl;

  // ignore: use_key_in_widget_constructors
  const SnapWidget({required this.imgUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(width: 1,color: const Color(0xff090f13),),
        borderRadius: BorderRadius.circular(0),
        color: Colors.teal.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800.withOpacity(0.7),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Image.network(
            "$imgUrl",
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 1,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$text",
              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
