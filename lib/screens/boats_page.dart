import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/chose_device.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/add_boat_screen.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:foka_app_v1/screens/login_screen.dart';
import 'package:foka_app_v1/utils/authentication.dart';
import 'package:foka_app_v1/utils/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class BoatsPage extends StatefulWidget {
  // final boatData;

  // const BoatsPage({Key? key}) : super(key: key);
  // BoatsPage({this.boatData});

  static const String id = 'boats_page';

  @override
  _BoatsPageState createState() => _BoatsPageState();
}

class _BoatsPageState extends State<BoatsPage> {
  final CarouselController _carouselController = CarouselController();
  int _current = 0;

  // List<dynamic> boats = [
  //   {'title': 'Boat 1', 'image': 'https://i.pinimg.com/550x/a7/f5/90/a7f5904f50f65424dbfb69f18e8f7753.jpg', 'description': 'Tap to Continue for Boat 1'},
  //   {'title': 'Boat 2', 'image': 'https://www.viewbug.com/media/mediafiles/2019/05/27/84896105_large.jpg', 'description': 'Tap to Continue for Boat 2'},
  //   {'title': 'Boat 3', 'image': 'https://i.pinimg.com/736x/b3/df/17/b3df17c88af0b6e56988d42cb2c35e63.jpg', 'description': 'Tap to Continue for Boat 3'}
  // ];

  // List<String> imageUrl = [
  //   'https://i.pinimg.com/550x/a7/f5/90/a7f5904f50f65424dbfb69f18e8f7753.jpg',
  //   'https://www.viewbug.com/media/mediafiles/2019/05/27/84896105_large.jpg',
  //   'https://i.pinimg.com/736x/b3/df/17/b3df17c88af0b6e56988d42cb2c35e63.jpg',
  // ];

  List<dynamic> boats = [];

  @override
  void initState() {
    super.initState();
    getBoats(Data().getBoatData());
  }

  void getBoats(boatData) {
    boats = boatData;
  }

  // Future test() async {
  //   var boatList = [];
  //   var url = Uri.parse('http://d615-183-82-204-6.ngrok.io/boatData?user=sathya@test.com');
  //   // password abcdefg
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     var decodedData = jsonResponse['data'];
  //     print(decodedData);
  //     for (int i = 0; i < decodedData.length; i++) {
  //       boatList.add({
  //         'title': decodedData[i]['boatname'],
  //         'image': imageUrl[i % 3],
  //         'description': 'Tap to continue to ' + decodedData[i]['boatname'],
  //       });
  //     }
  //     return boatList;
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090f13),
      floatingActionButton: FabCircularMenu(
        fabSize: 50.0,
        ringDiameter: 300,
        ringWidth: 80.0,
        fabColor: Colors.white,
        ringColor: Colors.black54,
        children: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AddBoatScreen.id),
            icon: const Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SelectService.id);
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          IconButton(
            onPressed: () {
              Authentication().signOut().then((value) {
                if (value) {
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                }
              });
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: boats.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Lottie.asset(
                      "assets/oops.json",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No Boats to Display",
                    style: GoogleFonts.montserrat(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Image.network(boats[_current]['image'], fit: BoxFit.cover),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                        // Colors.grey.shade50.withOpacity(1),
                        // Colors.grey.shade50.withOpacity(1),
                        // Colors.grey.shade50.withOpacity(1),
                        // Colors.grey.shade50.withOpacity(1),
                        // Colors.grey.shade50.withOpacity(0.0),
                        // Colors.grey.shade50.withOpacity(0.0),
                        // Colors.grey.shade50.withOpacity(0.0),
                        // Colors.grey.shade50.withOpacity(0.0),
                        const Color(0xff1A1E20).withOpacity(1),
                        const Color(0xff1A1E20).withOpacity(1),
                        const Color(0xff1A1E20).withOpacity(1),
                        const Color(0xff1A1E20).withOpacity(1),
                        const Color(0xff1A1E20).withOpacity(0.0),
                        const Color(0xff1A1E20).withOpacity(0.0),
                        const Color(0xff1A1E20).withOpacity(0.0),
                        const Color(0xff1A1E20).withOpacity(0.0),
                      ])),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        height: 500.0,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.70,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                      carouselController: _carouselController,
                      items: boats.map((boat) {
                        return Builder(
                          builder: (BuildContext context) {
                            return InkWell(
                              // onTap: () {
                              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                              //     return HomeScreen(hubId: boat['hubid'], boatName: boat['title']);
                              //   }));
                              // },
                              onTap: () {
                                Data().setHubId(boat['hubid']);
                                Data().setBoatName(boat['title']);
                                Navigator.pushNamed(context, HomeScreen.id);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xff111417),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 320,
                                        margin: const EdgeInsets.only(top: 30),
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Image.network(boat['image'], fit: BoxFit.cover),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        boat['title'],
                                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      // rating
                                      const SizedBox(height: 20),
                                      Container(
                                        child: Text(
                                          boat['description'],
                                          style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      //   duration: const Duration(milliseconds: 500),
                                      //   opacity: _current == boats.indexOf(boat) ? 1.0 : 0.0,
                                      //           child: Row(
                                      //             children: [
                                      //               const Icon(
                                      //                 Icons.star,
                                      //                 color: Colors.yellow,
                                      //                 size: 20,
                                      //               ),
                                      //               const SizedBox(width: 5),
                                      //               Text(
                                      //                 '4.5',
                                      //                 style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                                      //               )
                                      //             ],
                                      //           ),
                                      //         ),
                                      //         Container(
                                      //           child: Row(
                                      //             children: [
                                      //               Icon(
                                      //                 Icons.access_time,
                                      //                 color: Colors.grey.shade600,
                                      //                 size: 20,
                                      //               ),
                                      //               const SizedBox(width: 5),
                                      //               Text(
                                      //                 '2h',
                                      //                 style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                                      //               )
                                      //             ],
                                      //           ),
                                      //         ),
                                      //         Container(
                                      //           width: MediaQuery.of(context).size.width * 0.2,
                                      //           child: Row(
                                      //             children: [
                                      //               Icon(
                                      //                 Icons.play_circle_filled,
                                      //                 color: Colors.grey.shade600,
                                      //                 size: 20,
                                      //               ),
                                      //               const SizedBox(width: 5),
                                      //               Text(
                                      //                 'Watch',
                                      //                 style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                                      //               )
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    top: -MediaQuery.of(context).size.height * 0.065,
                    left: MediaQuery.of(context).size.width * 0.03,
                    child: Image.network(
                      'https://cdn.discordapp.com/attachments/841898285118652461/926791595108466748/foka_logo-removebg-preview_1.png',
                      height: 215,
                      width: 180,
                      color: Colors.white,
                    ),
                    // child: Text(
                    //   'Fokaboat | Smart App',
                    //   style: GoogleFonts.montserrat(
                    //     color: Colors.white,
                    //     fontSize: 30,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
    );
  }
}
