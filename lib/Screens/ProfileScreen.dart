import 'package:flutter/material.dart';
import 'package:note/Custom/cusText.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: cusText('Hemant sahu', 20, true),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 300,
              width: 300,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
