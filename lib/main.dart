import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note/Provider/NoteProvider.dart';
import 'package:note/Provider/UserProvider.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:note/Screens/HiddenDrawerScreen.dart';
import 'package:note/Screens/HomeScreen.dart';
import 'package:note/Screens/LogInScreen.dart';
import 'package:note/Screens/NoteDetailsScreen.dart';
import 'package:note/Screens/ProfileScreen.dart';
import 'package:note/Screens/SettingsScreen.dart';
import 'package:note/Screens/SignUpScreen.dart';
import 'package:note/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggedIn = true;
  @override
  void initState() {
    super.initState();
    isLoggedIn = _auth.currentUser != null;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider(),),
        ChangeNotifierProvider(create: (context) => UserDetailsProvider(),),
      ],
      child: MaterialApp(
        title: 'Note',
        theme: ThemeData(
          brightness: Brightness.light,
            useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Colors.grey[400]!,
            secondary: Colors.grey,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: Colors.grey[800]!,
            secondary: Colors.grey
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedIn? 'drawer' : 'login',
        routes: {
          'drawer' : (context) => HiddenDrawerScreen(),
          'home' : (context) => HomeScreen(openDrawer: (){},),
          'profile' : (context) => ProfileScreen(openDrawer: (){},),
          'setting' : (context) => SettingsScreen(openDrawer:() {},),
          'signup' : (context) => const SignUpScreen(),
          'login' : (context) => const LogInScreen(),
          'details' : (context) => NoteDetailsScreen(note: ModalRoute.of(context)?.settings.arguments as Note),
        },
      ),
    );
  }
}
