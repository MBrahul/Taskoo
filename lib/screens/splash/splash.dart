import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:taskoo/screens/home/mainHome.dart';
import 'package:taskoo/screens/welcome/welcome.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var isLogin = false;
  var uid = "";
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
    Timer(const Duration(milliseconds: 1400), () {
      if (isLogin) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return MainHome(uid);
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Welcome();
        }));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 35, 39, 49),
        child: Center(
            child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'Taskoo.',
              textStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 93, 52),
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'taskooFont'),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          isRepeatingAnimation: false,
        )),
      ),
    );
  }
}
