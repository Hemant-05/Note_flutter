import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/Custom/cusHeightGap.dart';
import 'package:note/Custom/cusSnackBar.dart';
import 'package:note/Custom/cusText.dart';
import 'package:note/Custom/cusTextField.dart';
import 'package:note/FirebaseAuth/FirebaseAuth.dart';
import '../Custom/cusElevetedButton.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuthServices services = FirebaseAuthServices();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController conPassController = TextEditingController();

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
              cusText(
                  'Please Enter your details to Create your account', 14, true),
              hGap(18),
              cusTextField('Name', nameController, 1, size, false),
              hGap(18),
              cusTextField('Email', emailController, 1, size, false),
              hGap(18),
              cusTextField('Password', passController, 1, size, false),
              hGap(18),
              cusTextField(
                  'Confirm Password', conPassController, 1, size, false),
              hGap(18),
              cusElevatedButton(context, 'Sign Up', _signUp, size),
              hGap(18),
              InkWell(
                onTap: () => Navigator.pushReplacementNamed(context, 'login'),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 16,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black),
                    children: const [
                      TextSpan(text: 'Already have an account'),
                      TextSpan(
                          text: ' \"Log in here \" ',
                          style: TextStyle(fontWeight: FontWeight.bold,),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    conPassController.dispose();
  }

  void _signUp() async {
    setState(() {
      isLoading = true;
    });
    String name = nameController.text.toString();
    String pass = passController.text.toString();
    String email = emailController.text.toString();
    String conPass = conPassController.text.toString();
    if (conPass == pass) {
      User? user = await services.signUpWithEmailAndPass(email, pass);
      if (user != null) {
        print("Users Account Created Successfully..."
            "\n Name is : $name");
        await services.addUserDetails(name, email, '');
        Navigator.pushReplacementNamed(context, 'drawer');
      } else {
        print("Some problem Accoured while creating account");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      showCusSnackBar(context, 'Check Pass');
    }
    isLoading = false;
  }
}
