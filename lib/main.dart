import 'package:flutter/material.dart';
import 'package:taskoo/screens/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
// for internet availability checkimport 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  // lock device in portriat mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'taskoo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Splash());
  }
}

//*******  UPDATES  ******//

// reminder for tasks
// make code maintainable and clean ************
//success rate update


// delopy
// read documaintaition of flutter deployment

