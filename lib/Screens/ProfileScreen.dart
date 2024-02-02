import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/Custom/cusSwipableButton.dart';
import 'package:note/Custom/cusText.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: cusText('Hemant sahu', 20, true),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 200,
                ),
              ),
            ),
            cusText(user?.displayName?? 'Not Fetch', 22, true),
            cusSwipeableButton(context,(){},'Slide to update profile',false),
          ],
        ),
      ),
    );
  }
}
