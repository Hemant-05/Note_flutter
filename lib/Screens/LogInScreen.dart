import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/Custom/cusElevetedButton.dart';
import 'package:note/Custom/cusHeightGap.dart';
import 'package:note/Custom/cusText.dart';
import 'package:note/Custom/cusTextField.dart';
import 'package:note/FirebaseAuth/FirebaseAuth.dart';
import 'package:note/Screens/HomeScreen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  FirebaseAuthServices services = FirebaseAuthServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hGap(23),
            cusText('Welcome', 30, true),
            cusText('Please Enter your details to continue', 12, true),
            hGap(18),
            cusTextField('Email', emailController, 1, size, false),
            hGap(18),
            cusTextField('Password', passController, 1, size, false),
            hGap(18),
            cusElevatedButton(context, 'Log In', _signIn, size),
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
              onPressed: () {
                // services.signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Log In with google',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                ],
              ),
            ),
            hGap(18),
            InkWell(
              onTap: () => Navigator.pushReplacementNamed(context, 'signup'),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 16,
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black),
                  children: const [
                    TextSpan(text: 'Don \' have an account'),
                    TextSpan(
                      text: '\" Sign up here \" ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  void _signIn() async {
    setState(() {
      isLoading = true;
    });
    String pass = passController.text.toString();
    String email = emailController.text.toString();
    User? user = await services.signInWithEmailAndPass(email, pass);
    if (user != null) {
      print("Users Logged In Successfully..."
          "\n Name is : $email");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      print("Some problem Accoured while User sign in ");
    }
    isLoading = false;
  }
}
