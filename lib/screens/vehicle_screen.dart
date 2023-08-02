
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:OTA/screens/home_screen.dart';

class vehicleScreen extends StatelessWidget {
  final CarData carData;
  const vehicleScreen({
    Key? key,
    required this.carData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = carData.name;
    final market = carData.market;
    final currentVersion = carData.currVersion;
    final lastUpdateDate = carData.dateUpdate;

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          imglogo12,
          height: 70,
          width: 70,
          fit: BoxFit.scaleDown,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {},
            icon: IconButton(
              icon: const Icon(
                Icons.navigate_before_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            )),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: SizedBox(
              height: 10,
              width: double.infinity,
              child: SvgPicture.asset(
                imgTabbar,
                fit: BoxFit.cover,
              ),
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              children: [
                Text(
                  "Vehicle Identification Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$name',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 30),
                Text(
                  "Market",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text('$market', style: TextStyle(fontSize: 20)),
                SizedBox(height: 30),
                Text(
                  "Current Version",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  currentVersion != '' ? "$currentVersion" : "N/A",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 30),
                Text(
                  "Last Update",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "${lastUpdateDate}",
  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
