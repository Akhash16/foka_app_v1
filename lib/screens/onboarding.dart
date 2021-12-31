import 'package:flutter/material.dart';
import 'package:foka_app_v1/components/rounded_button.dart';
import 'package:foka_app_v1/screens/boats_page.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);
  static const id = "onboarding.dart";

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  static const TextStyle greyStyle = TextStyle(fontSize: 40.0, color: Colors.grey, fontFamily: "Product Sans");
  static const TextStyle whiteStyle = TextStyle(fontSize: 40.0, color: Colors.white, fontFamily: "Product Sans");

  static const TextStyle boldStyle = TextStyle(
    fontSize: 50.0,
    color: Colors.black,
    fontFamily: "Product Sans",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle descriptionGreyStyle = TextStyle(
    color: Colors.grey,
    fontSize: 20.0,
    fontFamily: "Product Sans",
  );

  static const TextStyle descriptionWhiteStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontFamily: "Product Sans",
  );

  @override
  Widget build(BuildContext context) {
    final pages = [
      Container(
        color: const Color(0xffffffff),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "https://www.aihr.com/wp-content/uploads/onboarding.png",
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Text(
                  //   "Lorem",
                  //   style: greyStyle,
                  // ),
                  Text(
                    "Welcome",
                    style: boldStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Thank you for choosing fokaboat! We are glad to have you on board.",
                    style: descriptionGreyStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
        color: const Color(0xFF55006c),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
            ),
            Image.network("https://github.com/sagarshende23/flutter_liquid_swipe/blob/master/assets/img/secondImage.png?raw=true"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Instant",
                    style: whiteStyle,
                  ),
                  Text(
                    "Updates",
                    style: boldStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Know where your fleet is and how it's doing. Anytime. All-time.",
                    style: descriptionWhiteStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
            ),
            Image.network("https://github.com/sagarshende23/flutter_liquid_swipe/blob/master/assets/img/firstImage.png?raw=true"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Experience",
                    style: whiteStyle,
                  ),
                  const Text(
                    "Technology",
                    style: boldStyle,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "With one click, you'll be ready to enter into the world of Fokaboat.\n\nClick on continue to experience the latest fleet management technology.",
                    style: descriptionWhiteStyle,
                  ),
                  Center(child: RoundedButton(title: 'Continue', color: Colors.deepPurple, onPressed: () => Navigator.pushNamed(context, BoatsPage.id))),
                ],
              ),
            )
          ],
        ),
      ),
    ];

    return Scaffold(
      body: Builder(
        builder: (context) {
          return LiquidSwipe(
            pages: pages,
            fullTransitionValue: 880,
            waveType: WaveType.liquidReveal,
            slideIconWidget: const Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            positionSlideIcon: 0.8,
            // onPageChangeCallback: (page) {
            //   print(page);
            // },
            liquidController: LiquidController(),
          );
        },
      ),
    );
  }
}
