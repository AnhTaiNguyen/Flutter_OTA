import 'package:OTA/screens/vehicle_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:OTA/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:OTA/Models/user_model.dart';

const String boschlogo = 'assets/images/boschsymbol.svg';
const String graphicsvg = 'assets/images/supergraphic.svg';
final Widget boschsvg = SvgPicture.asset(
  boschlogo,
  semanticsLabel: 'Bosch Logo',
  height: 70,
  width: 70,
  fit: BoxFit.scaleDown,
);



class UpdateScreen extends StatefulWidget {
  final CarData carData;

  const UpdateScreen({required this.carData, Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  UserModel? userData;

  bool availableUpdate = true;
  String description = '';
  String versionName = '';


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
        final userDataFromSnapshot =
            UserModel.fromSnapshot(snapshot.docs.first);
        setState(() {
          userData = userDataFromSnapshot;
        });
        final carId = userDataFromSnapshot.carId;
       
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final carData = widget.carData;
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
          ),
        ),
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: availableUpdate
                    ? Container(
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: const Text(
                                  'New available update\n\n',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Version",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(),
                              child: Text(
                                versionName.isNotEmpty ? versionName : 'N/A',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Description",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Center(
                                    child: Text(
                                      description.isNotEmpty
                                          ? description
                                          : 'N/A',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 30),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            Text(
                              'No need to update.',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\n\n\nYour current software is the latest version.\n\nCheck Vehicle Information for more details!',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
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
