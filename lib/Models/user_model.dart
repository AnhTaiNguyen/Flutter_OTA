import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final String password;
  final String carId;

  const UserModel(
      {this.id,
      required this.email,
      required this.password,
      required this.carId});

  toJson() {
    return {
      "email": email,
      "password": password,
      "carId": carId,
    };
  }

  //Map user fetched from firebase to UserModel
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data['email'],
        password: data['password'],
        carId: data['carId']);
  }
  // Fetch a single user by their ID
  static Future<UserModel> getUserById(String carId) async {
    final document = await FirebaseFirestore.instance
        .collection('user_info')
        .doc(carId)
        .get();

    return UserModel.fromSnapshot(document);
  }

  // Fetch all users
  static Future<List<UserModel>> getAllUsers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('user_info').get();

    return snapshot.docs
        .map((document) => UserModel.fromSnapshot(document))
        .toList();
  }
}
