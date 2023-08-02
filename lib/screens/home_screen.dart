import 'dart:convert';

import 'package:OTA/screens/vehicle_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../screens/diagnostic_screen.dart';
import '../screens/update_screen.dart';
import '../Models/user_model.dart';


import '../reusable_widgets/yesCancelDialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Constants for image paths
const imglogo12 = "assets/images/boschsymbol.svg";
const imgTabbar = "assets/images/supergraphic.svg";

class CarData {
  final String id;
  final String name;
  final String market;
  final String currVersion;
  final String dateUpdate;
  final bool isNewVersionAvailable;

  CarData({
    required this.id,
    required this.name,
    required this.market,
    required this.currVersion,
    required this.dateUpdate,
    required this.isNewVersionAvailable,
  });

  // Factory method to create a CarData object from JSON data
  factory CarData.fromJson(Map<String, dynamic> json) {
  return CarData(
    id: json['id'],
    name: json['name'],
    market: json['description'][0]['market'],
    currVersion: json['description'][0]['CurrVersion'],
    dateUpdate: json['description'][0]['dateUpdate'],
    isNewVersionAvailable: json['description'][0]['newVer'] == "true", // Parse as bool
  );
}

}


class _HomeScreenState extends State<HomeScreen> {
  UserModel? userData;
  String carId = '';
  String vehicleNameOnScreen = '';
  String vehicleMarket = '';
  bool availableUpdate = false;
  CarData? _carData; 

  Future<void> fetchCarDataAndCheckMatch(String carId) async {
    try {
      final String response = await rootBundle.loadString('assets/data.json');
      final data = await json.decode(response);
      final List<dynamic> carList = data["car"];

      // Find the car with the specified carId
      final carData = carList.firstWhere(
        (car) => car["id"] == carId,
        orElse: () => null,
      );

      if (carData != null) {
        final carInfo = CarData.fromJson(carData);
        setState(() {
          vehicleNameOnScreen = carInfo.name;
          vehicleMarket = carInfo.market;
          availableUpdate = carInfo.isNewVersionAvailable;
          _carData = carInfo; // Store the fetched carData
        });
      } else {
        // Car with matching carId not found
        // Handle the case when the carId doesn't match any car
        // For example, show an error message or set default values
        setState(() {
          vehicleNameOnScreen = 'N/A';
          vehicleMarket = 'N/A';
          availableUpdate = false;
          _carData = null;
        });
      }
    } catch (e) {
      // Handle any errors that may occur during data fetching or processing
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final snapshot = await FirebaseFirestore.instance
        .collection('user_info')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final userDataFromSnapshot = UserModel.fromSnapshot(snapshot.docs.first);
      setState(() {
        userData = userDataFromSnapshot;
      });
      final carId = userDataFromSnapshot.carId;
      fetchCarDataAndCheckMatch(carId);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Show the logout dialog on back button press
        yesCancelDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: SvgPicture.asset(
            imglogo12,
            height: 70,
            width: 70,
            fit: BoxFit.scaleDown,
          ),
          actions: [
            IconButton(
              color: Colors.black,
              icon: Icon(Icons.logout),
              onPressed: () {
                // Show the logout dialog on logout button press
                yesCancelDialog(context);
              },
            ),
          ],
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: SizedBox(
              height: 10,
              width: double.infinity,
              child: SvgPicture.asset(
                imgTabbar,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
           child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
            child: Column(
              children: [
                Text(
                  '${vehicleNameOnScreen}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CarWidget(vehicleNameOnScreen),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => vehicleScreen(carData: _carData!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                      primary: Colors.white,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Vehicle Information",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateScreen(carData: _carData!)
                          // availableUpdate: isNewVersionAvailable),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                      primary: Colors.white,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        if (availableUpdate == true)
                          Positioned(
                            top: 0,
                            right: 30,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiagnosticPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                      primary: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Diagnostic",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
