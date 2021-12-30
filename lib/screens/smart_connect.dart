import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SmartConnet extends StatefulWidget {
  const SmartConnet({Key? key}) : super(key: key);

  static const String id = 'smart_connect';

  @override
  _SmartConnetState createState() => _SmartConnetState();
}

class _SmartConnetState extends State<SmartConnet> {
  int indexValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff090f13),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "Boat Name",
              //     style: GoogleFonts.lexendDeca(
              //         color: const Color(0xffffffff),
              //         fontSize: 28,
              //         fontWeight: FontWeight.w700),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff1d2429),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Relay 1",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ToggleSwitch(
                            cornerRadius: 20,
                            animate: true,
                            fontSize: 10,
                            inactiveBgColor: const Color(0xff303030),
                            inactiveFgColor: Colors.white,
                            minWidth: MediaQuery.of(context).size.width * 0.13,
                            initialLabelIndex: indexValue,
                            totalSwitches: 2,
                            labels: const ['ON', 'OFF'],
                            customTextStyles: [
                              GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ],
                            onToggle: (index) {
                              // print('switched to: $index');
                              indexValue = index;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff1d2429),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Relay 2",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ToggleSwitch(
                            cornerRadius: 20,
                            animate: true,
                            fontSize: 10,
                            inactiveBgColor: const Color(0xff303030),
                            inactiveFgColor: Colors.white,
                            minWidth: MediaQuery.of(context).size.width * 0.13,
                            initialLabelIndex: indexValue,
                            totalSwitches: 2,
                            labels: const ['ON', 'OFF'],
                            customTextStyles: [
                              GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ],
                            onToggle: (index) {
                              // print('switched to: $index');
                              indexValue = index;
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:  const EdgeInsets.fromLTRB(8,16,8,8),
                child: InkWell(
                  onTap: null,
                  child: DottedBorder(
                    dashPattern: const [10, 14],
                    strokeWidth: 2,
                    color: Colors.grey.shade600,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_box_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Tap to add new device",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
