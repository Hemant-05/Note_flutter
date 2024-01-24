import 'package:flutter/material.dart';
import 'package:note/Screens/LogInScreen.dart';

import '../Custom/custom_item.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    conPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hGap(100),
              cusText('Welcome', 30, true),
              cusText('Please Enter your details to Create your account', 14, true),
              hGap(18),
              cusTextField('Name', nameController, 1, size,false),
              hGap(18),
              cusTextField('Email', emailController, 1, size,false),
              hGap(18),
              cusTextField('Password', passController, 1, size,false),
              hGap(18),
              cusTextField('Confirm Password', conPassController, 1, size,false),
              hGap(18),
              cusElevatedButton(context, 'Sign Up', () {}, size),
              hGap(18),
              InkWell(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LogInScreen(),
                    ),
                  ),
                  child: cusText(
                      'Already have an account \"Log In here\" ', 16, true)),
            ],
          ),
        ),
      ),
    );
  }
}