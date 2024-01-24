import 'package:flutter/material.dart';
import 'package:note/Custom/custom_item.dart';
import 'package:note/Screens/HomeScreen.dart';
import 'package:note/Screens/SignUpScreen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hGap(23),
            cusText('Welcome', 30, true),
            cusText('Please Enter your details to continue', 12, true),
            hGap(18),
            cusTextField('Email', emailController, 1, size,false),
            hGap(18),
            cusTextField('Password', passController, 1, size,false),
            hGap(18),
            cusElevatedButton(context, 'Log In', () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                ),
              );
            }, size),
            hGap(18),
            cusText('Or', 16, true),
            hGap(18),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                maximumSize: Size(size.width * .9, size.height * .075),
                minimumSize: Size(size.width * .9, size.height * .075),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apple),
                  cusText('Log In with google', 18, false),
                ],
              ),
            ),
            hGap(18),
            InkWell(
                onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignUpScreen(),
                      ),
                    ),
                child: cusText(
                    'Don\'t have and account \"Sing up here\" ', 16, true),),
          ],
        ),
      ),
    );
  }
}
