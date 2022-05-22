import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import "package:flutter/material.dart";
import 'package:foka_app_v1/components/service.dart';
import 'package:foka_app_v1/screens/make_sure.dart';
import 'package:foka_app_v1/utils/data.dart';

class SelectService extends StatefulWidget {
  const SelectService({Key? key}) : super(key: key);
  static const String id = "choose_device";

  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  List<Service> services = [
    Service(const AutoSizeText('Location Tracker'), 'https://img.icons8.com/stickers/344/worldwide-location.png'),
    Service(const AutoSizeText('THS Monitor'), 'https://img.icons8.com/external-flatart-icons-flat-flatarticons/344/external-temperature-internet-of-things-flatart-icons-flat-flatarticons.png'),
    Service(const AutoSizeText('Security Monitor'), 'https://img.icons8.com/color/344/wallmount-camera.png'),
    Service(const AutoSizeText('Smart Connect'), 'https://img.icons8.com/color/344/share-2.png'),
    Service(const AutoSizeText('Fluid Monitor'), 'https://img.icons8.com/color/344/water.png'),
    Service(const AutoSizeText('Float Sensor'), 'https://img.icons8.com/color/344/period-slider.png'),
  ];

  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        backgroundColor: const Color(0xff090f13),
        // backgroundColor: const Color(0xff1A1E20),
        floatingActionButton: selectedService >= 0
            ? FloatingActionButton(
                onPressed: () {
                  print("selectedService " + selectedService.toString());
                  Data().setDeviceType("${selectedService + 1}");
                  Navigator.pushNamed(context, MakeSure.id);
                },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                backgroundColor: Colors.blue,
              )
            : null,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 400),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
                    child: Text(
                      'Choose type of device',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ];
          },
          body: FadeInDown(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 600),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Expanded(
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return serviceContainer(services[index].imageURL, services[index].name.data!, index);
                      }),
                ),
              ]),
            ),
          ),
        ));
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedService == index)
            selectedService = -1;
          else
            selectedService = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedService == index ? Colors.grey.shade900 : Colors.black87,
          border: Border.all(
            color: selectedService == index ? Colors.blue : Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Image.network(image, height: 80),
          const SizedBox(
            height: 20,
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          )
        ]),
      ),
    );
  }
}
