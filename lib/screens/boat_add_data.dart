import 'package:flutter/material.dart';

class BoatAddData extends StatefulWidget {
  const BoatAddData({Key? key}) : super(key: key);

  static const String id = 'boat_add_data';

  @override
  _BoatAddDataState createState() => _BoatAddDataState();
}

class _BoatAddDataState extends State<BoatAddData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Enter Boat Id'),
          TextField(),
        ],
      ),
    );
  }
}
