import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/home_screen.dart';
import 'package:foka_app_v1/screens/add_boat_screen.dart';

class BoatsPage extends StatefulWidget {
  const BoatsPage({Key? key}) : super(key: key);

  static const String id = 'boats_page';

  @override
  _BoatsPageState createState() => _BoatsPageState();
}

class _BoatsPageState extends State<BoatsPage> {
  final CarouselController _carouselController = CarouselController();
  int _current = 0;

  List<dynamic> movies = [
    {
      'title': 'Black Widow',
      'image':
          'https://www.moviepostersgallery.com/wp-content/uploads/2020/08/Blackwidow2.jpg',
      'description': 'Black Widow'
    },
    {
      'title': 'The Suicide Squad',
      'image':
          'https://static.wikia.nocookie.net/headhuntersholosuite/images/7/77/Suicide_Squad%2C_The.jpg/revision/latest?cb=20210807172814',
      'description': 'The Suicide Squad'
    },
    {
      'title': 'Godzilla Vs Kong',
      'image':
          'https://pbs.twimg.com/media/EwTsO9CVcAUxoMM?format=jpg&name=large',
      'description': 'Godzilla Vs Kong'
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          size: 30.0,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddBoatScreen(),
          );
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: InkWell(
          // onTap: () {
          //   Navigator.pushNamed(context, HomeScreen.id);
          // },
          child: Stack(
            children: [
              Image.network(movies[_current]['image'], fit: BoxFit.cover),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
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
                child: InkWell(
                  onTap: () => HomeScreen.id,
                  child: CarouselSlider(
                    options: CarouselOptions(
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
                    items: movies.map((movie) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
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
                                      child: Image.network(movie['image'],
                                          fit: BoxFit.cover),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      movie['title'],
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    // rating
                                    const SizedBox(height: 20),
                                    Container(
                                      child: Text(
                                        movie['description'],
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey.shade600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      opacity: _current == movies.indexOf(movie)
                                          ? 1.0
                                          : 0.0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '4.5',
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors
                                                            .grey.shade600),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Colors.grey.shade600,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '2h',
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors
                                                            .grey.shade600),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.play_circle_filled,
                                                    color: Colors.grey.shade600,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    'Watch',
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors
                                                            .grey.shade600),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      );
                    }).toList(),
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
