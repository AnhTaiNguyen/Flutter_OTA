import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:OTA/reusable_widgets/reusable_widget.dart';
import 'package:OTA/screens/diagnostic_screen.dart';
import 'package:OTA/screens/update_screen.dart';
import 'package:OTA/screens/vehicel_screen.dart';
import 'package:OTA/Models/user_model.dart';

import '../Models/NetworkHandler.dart';
import '../reusable_widgets/yesCancelDialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Constants for image paths
const imglogo12 = "assets/images/boschsymbol.svg";
const imgTabbar = "assets/images/supergraphic.svg";

class VehicleInfo {
  final String vehicleName;
  final String vehicleMarket;

  VehicleInfo({
    required this.vehicleName,
    required this.vehicleMarket,
  });

  // Factory method to create a VehicleInfo object from JSON data
  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
        vehicleName: json['description'], vehicleMarket: json['name']);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userData;
  NetworkHandler networkHandler = NetworkHandler();
  late Future<VehicleInfo> futureVehicleInfo;
  String carId = '';
  String vehicleNameOnScreen = '';
  String vehicleMarket = '';
  bool availableUpdate = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch Version data from the server
  void fetchData(String carId) async {
    var response = await networkHandler.get(
      "https://device.eu1.bosch-iot-rollouts.com/CF738D39-C92C-49D7-A751-CDBEA75BDCD8/controller/v1/$carId",
    );
    if (response is Map<String, dynamic> &&
        response['_links'].containsKey('deploymentBase')) {
      setState(() {
        availableUpdate = true;
      });
    } else {
      setState(() {
        availableUpdate = false;
      });
    }
  }

  // Fetch vehicle information from the server
  Future<VehicleInfo> fetchVehicleInfo(String carId) async {
    var response = await networkHandler.getVehicleInfo(
      "https://api.eu1.bosch-iot-rollouts.com/rest/v1/targets/$carId",
    );
    setState(() => vehicleNameOnScreen = response['description']);
    vehicleMarket = response['name'];
    return VehicleInfo.fromJson(response);
  }

  // Get carId from the user info
  void fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('user_info')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final userDataFromSnapshot =
            UserModel.fromSnapshot(snapshot.docs.first);
        setState(() {
          userData = userDataFromSnapshot;
        });
        this.carId = userDataFromSnapshot.carId;
        fetchVehicleInfo(carId);
        fetchData(carId);
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
                  CarWidget(vehicleMarket),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => vehicleScreen(),
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
                          builder: (context) => UpdateScreen(),
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
