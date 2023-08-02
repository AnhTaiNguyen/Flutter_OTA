import 'package:OTA/screens/update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:OTA/reusable_widgets/reusable_widget.dart';
import 'package:OTA/screens/home_screen.dart';
import 'package:OTA/screens/reset_password.dart';
import 'package:OTA/screens/signup_screen.dart';
import 'package:OTA/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const imglogo12 = "assets/images/boschsymbol.svg";
const imgTabbar = "assets/images/supergraphic.svg";

final Widget boschsvg = SvgPicture.asset(
  boschlogo,
  semanticsLabel: 'Bosch Logo',
  height: 70,
  width: 70,
  fit: BoxFit.contain,
);

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _emailErr;
  var _passWordErr;
  var _emailInvalid = false;
  var _passInvalid = false;
  bool isEmailValid(String email) {
    return true;
  }

  void _showLoginSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Login Successful!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 224, 221, 221),
        backgroundColor: Colors.white,

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
            )),
      ),
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/boschlogo.png"),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter username", Icons.person_outline, false,
                    _emailTextController,
                    errorText: _emailInvalid ? _emailErr : null),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                  errorText: _passInvalid ? _passWordErr : null,
                ),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "Sign In", () {
                  if (!isEmailValid(_emailTextController.text)) {
                    setState(() {
                      _emailInvalid = true;
                      _emailErr = "Invalid username ";
                    });
                    return; // Stop execution if the email is invalid
                  }
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    print("Sign In Account");
                    _showLoginSuccessSnackBar();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  }).catchError((error) {
                    setState(() {
                      _passInvalid = true;
                      _passWordErr = "Incorrect password";
                    });
                    print("Error: ${error.toString()}");
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
