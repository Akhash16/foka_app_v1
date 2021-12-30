import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Boat Name",
                style: GoogleFonts.lexendDeca(
                    color: const Color(0xffffffff),
                    fontSize: 28,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.grey,
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Text("data"),
                          
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.grey,
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Text("data"),

                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
