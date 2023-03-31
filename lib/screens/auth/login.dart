import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/custom%20widgets/snackbar.dart';
import 'package:taskoo/screens/auth/signup.dart';
import 'package:taskoo/screens/home/mainHome.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool obsure = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void login() async {
    // show loading pop
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.red,
          ));
        });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) {
        //pop the dialog
        Navigator.of(context).pop();
        // move to main home
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return MainHome(value.user!.uid);
        }));
      });
    } on FirebaseAuthException catch (e) {
      // pop the dialog
      Navigator.of(context).pop();
      if (e.code == 'user-not-found') {
        snackbar("User Not Found", context);
      } else if (e.code == 'wrong-password') {
        snackbar("Wrong Credentials", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 35, 39, 49),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Taskoo',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'taskooFont',
                    color: Color.fromARGB(255, 255, 93, 52),
                    fontSize: 35,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'welcomeFont',
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: email,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                    label: const Text(
                      "Email",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.white60)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 241, 116, 84)))),
              ),
              const SizedBox(
                height: 17,
              ),
              TextField(
                controller: password,
                obscureText: obsure,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (obsure) {
                            obsure = false;
                          } else {
                            obsure = true;
                          }
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          size: 28,
                          color: Colors.white70,
                        )),
                    label: const Text(
                      "Password",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.white60)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 241, 116, 84)))),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 93, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23))),
                child: const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return SignUp();
                  }));
                },
                child: RichText(
                    textAlign: TextAlign.end,
                    text: const TextSpan(children: <TextSpan>[
                      TextSpan(text: "Don't have an account? "),
                      TextSpan(
                          text: "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 18))
                    ], style: TextStyle(color: Colors.white70))),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
