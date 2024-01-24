import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note/Provider/NoteProvider.dart';
import 'package:note/Screens/HomeScreen.dart';
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider(),),
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
        home: HomeScreen(),
      ),
    );
  }
}
