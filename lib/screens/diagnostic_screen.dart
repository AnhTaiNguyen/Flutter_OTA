import 'package:flutter/material.dart';
import 'package:OTA/utils/color_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../reusable_widgets/yesCancelDialog.dart';
import 'home_screen.dart';

class DiagnosticPage extends StatefulWidget {
  const DiagnosticPage({Key? key}) : super(key: key);

  @override
  _DiagnosticPageState createState() => _DiagnosticPageState();
}

const imglogo12 = "assets/images/boschsymbol.svg";
const imgTabbar = "assets/images/supergraphic.svg";

class _DiagnosticPageState extends State<DiagnosticPage> {
  Future<void> DiagnosticDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "information".toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text("Feature Is Now In Development"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => DiagnosticDialog(context));
    return Scaffold(
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
              yesCancelDialog(context);
            },
          ),
        ],
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
          color: Colors.white,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/diagnostic.png'),
                fit: BoxFit.fill,
              ),
            ),
          )),
    );
  }
}
