import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fill,
    width: 240,
    height: 240,
    // color: Colors.white,
  );
}

class CarWidget extends StatelessWidget {
  final String vehicleNameOnScreen;

  CarWidget(this.vehicleNameOnScreen);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getCarImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return Image.asset(
            snapshot.data!,
            fit: BoxFit.fill,
            width: 400,
            height: 300,
          );
        } else {
          return Text('Image Not Found');
        }
      },
    );
  }

  Future<String> _getCarImage() async {
    // Simulate an asynchronous operation here to fetch the image path
    await Future.delayed(Duration(seconds: 1));

    // Map the vehicleNameOnScreen to the corresponding image path
    if (vehicleNameOnScreen.contains('Hyundai Santa Fe _0')) {
      return 'assets/images/hyundai.png';
    } else if (vehicleNameOnScreen.toLowerCase().contains('kia k3')) {
      return 'assets/images/kia_k3.png';
    } else if (vehicleNameOnScreen.contains('Hyundai Santa Fe _1')) {
      return 'assets/images/hyundaiSantaFe1.png';
    }
    // If no match is found, return a default image path
    return '';
  }
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    {String? errorText}) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      errorText: errorText,
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}
