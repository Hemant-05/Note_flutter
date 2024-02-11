import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:note/Resources/UserModel.dart';
import 'package:note/Resources/Utils.dart';

class UserDetailsProvider extends ChangeNotifier {
  late UserModel model;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserDetailsProvider() {
    getUserDetails();
  }

  Future<UserModel> getUserDetails() async {
    final data = await _firestore.collection('users').doc(user?.uid).get();
    var map = data.data();
    model = UserModel(
        name: map?['name'],
        email: map?['email'],
        uid: map?['uid'],
        photoUrl: map?['photoUrl'],
    );
    notifyListeners();
    return model;
  }
}
