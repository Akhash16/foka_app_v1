import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/security_monitor.dart';

class SnapsScreen extends StatefulWidget {
  const SnapsScreen({Key? key}) : super(key: key);
  static const id = "snaps_screen";

  @override
  _SnapsScreenState createState() => _SnapsScreenState();
}

class _SnapsScreenState extends State<SnapsScreen> {
  List<String> snaps = [
    "https://i.ytimg.com/vi/QZRQaE1a0hU/maxresdefault.jpg",
    "https://i1.sndcdn.com/artworks-KvOyhrp1m4i4KfUv-U1fZCQ-t500x500.jpg",
    "https://www.anime-planet.com/images/characters/147676.jpg?t=1568503248",
    "https://i.pinimg.com/originals/ac/c4/58/acc4588c3637fc185d6a09449b4fc766.png"
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.network(
                snaps[index],
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: snaps.length,
          pagination: const SwiperPagination(builder: SwiperPagination.dots),
          control: const SwiperControl(color: Colors.white),
        ),
      ),
    );
  }
}
