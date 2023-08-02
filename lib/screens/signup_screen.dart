import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

import 'package:OTA/reusable_widgets/reusable_widget.dart';
import 'package:OTA/screens/signin_screen.dart';
import 'package:OTA/utils/color_utils.dart';
import 'package:flutter_svg/svg.dart';

const imglogo12 = "assets/images/boschsymbol.svg";
const imgTabbar = "assets/images/supergraphic.svg";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

var _emailErr;
var _passWordErr;
var _emailInvalid = false;
var _passInvalid = false;
bool isEmailValid(String email) {
  return email.endsWith("@gmail.com");
}

CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('user_info');

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _carIdTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> yesCancelDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "instruction".toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text("Contact Bosch Office to get your Car ID"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showRegisSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Register Account Successful!"),
        duration: Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Color.fromARGB(227, 239, 236, 236).withOpacity(0.9),
          elevation: 0,
          title: SvgPicture.asset(
            imglogo12,
            height: 80,
            width: 90,
            fit: BoxFit.scaleDown,
          ),
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
              ))),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.1,
                0.4,
                0.6,
                0.9,
              ],
              colors: [
                Colors.yellow,
                Colors.red,
                Colors.indigo,
                Colors.teal,
              ],
            )
          ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/boschlogo.png"),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Email",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                  errorText: _emailInvalid ? _emailErr : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                  errorText: _passInvalid ? _passWordErr : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                // Add an icon button to the car ID text field.
                Row(
                  children: [
                    Expanded(
                      child: reusableTextField(
                        "Enter your Car ID",
                        Icons.car_crash,
                        false,
                        _carIdTextController,
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.info_outline_rounded),
                      onPressed: () {
                        setState(() {
                          yesCancelDialog(context);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () async {
                  if (!isEmailValid(_emailTextController.text)) {
                    setState(() {
                      _emailInvalid = true;
                      _emailErr = "Invalid username or phone number";
                    });
                    return;
                  }

                  // bool isRegistered = await isUsernameOrPhoneNumberRegistered(
                  //     _emailTextController.text);
                  // if (isRegistered) {
                  //   setState(() {
                  //     _emailInvalid = true;
                  //     _emailErr = "Username or phone number already registered";
                  //   });
                  //   return;
                  // }

                  FirebaseFirestore.instance
                    ..collection("user_info").add({
                      'email': _emailTextController.text,
                      'password': _passwordTextController.text,
                      'carId': _carIdTextController.text
                    });
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    print("Created New Account");
                    _showRegisSuccessSnackBar();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );
                  }).catchError((error) {
                    setState(() {
                      _passInvalid = true;
                      _passWordErr = "Password should be at least 6 characters";
                    });
                    print("Error: ${error.toString()}");
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
