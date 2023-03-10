import 'package:flutter/material.dart';
import 'package:taskoo/screens/auth/login.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 35, 39, 49)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                const Expanded(
                  // flex: 1,
                  child: Text(
                    "Taskoo",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 93, 52),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              fontSize: 33, fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                        TextSpan(text: "Manage your\ntasks & everything\nwith"),
                        TextSpan(
                            text: " taskoo",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 93, 52),
                            ))
                      ])),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Center(
                  child: Image.asset(
                    "assets/images/welcome-removebg-preview.png",
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 3.5,
                  ),
                ),
                const Text(
                  "When you're overwhelmed by the\namount of work you have on your\nplate, stop and rethink.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return Login();
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 93, 52),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21))),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                top: 12.0, bottom: 12, right: 15, left: 15),
                            child: Text(
                              "Let's Start",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
