import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/screens/home/mainHome.dart';
import 'package:taskoo/screens/welcome/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService().intializeNotification();
  // NotificationService().showNotification(1, 'wake up', 'body');
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLogin = false;
  var uid;
  void checkLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        uid = user.uid;
        isLogin = true;
        setState(() {});
        // print(uid);
      }
    });
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: isLogin ? MainHome(uid) : const Welcome());
  }
}

// add splash screen
// work on theme date
// reminder for tasks
//integrate search fillter


