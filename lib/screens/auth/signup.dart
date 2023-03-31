import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/screens/auth/login.dart';
import 'package:taskoo/screens/home/mainHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoo/custom%20widgets/snackbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection("users");

  signUp() async {
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
          .createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      )
          .then((value) {
        // save username in user collection
        users.add({
          "userId": value.user!.uid,
          "userName": name.text.toString(),
          "imageUrl": ""
        });
        // pop the dialog
        Navigator.of(context).pop();

        // enter in the home

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return MainHome(value.user!.uid);
        }));
      });
    } on FirebaseAuthException catch (e) {
      // pop the dialog
      Navigator.of(context).pop();
      if (e.code == 'weak-password') {
        snackbar("Choose A Strong password", context);
      } else if (e.code == 'email-already-in-use') {
        snackbar("Account already exists", context);
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  bool obsure = true;
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
              TextField(
                controller: name,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                    label: const Text(
                      "Name",
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
                  signUp();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 93, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23))),
                child: const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "Sign Up",
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
                    return Login();
                  }));
                },
                child: RichText(
                    textAlign: TextAlign.end,
                    text: const TextSpan(children: <TextSpan>[
                      TextSpan(text: "Already have an account? "),
                      TextSpan(
                          text: "log In",
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
