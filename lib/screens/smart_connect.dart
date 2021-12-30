import 'package:flutter/material.dart';

class SmartConnet extends StatefulWidget {
  const SmartConnet({Key? key}) : super(key: key);

  static const String id = 'smart_connect';

  @override
  _SmartConnetState createState() => _SmartConnetState();
}

class _SmartConnetState extends State<SmartConnet> {
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: const Icon(Icons.arrow_back_ios_new),
        title: const Center(child: Text("Smart Connect")),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: const Color(0xff090f13),
    );
  }
}
