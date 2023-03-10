import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/screens/welcome/welcome.dart';

class Profile extends StatefulWidget {
  String username;
  var allDone;
  var allPending;

  Profile(this.username, this.allDone, this.allPending);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool reminder = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color.fromARGB(255, 35, 39, 49),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(
                    color: Colors.red, spreadRadius: 2.0, blurRadius: 10.0)
              ], borderRadius: BorderRadius.circular(105)),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPDxExA79GMgWNjwLYOMbd6eLMqwTJCtHd3_EAKm-9pitWIl78GvX_QisowoXPLfmJ6GT6nJ8zODc&usqp=CAU&ec=48600113"),
                radius: 80,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.username,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.playlist_add_check_circle,
                        size: 40,
                        color: Color.fromARGB(255, 255, 93, 52),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Completed Task",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            widget.allDone.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 23),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width / 2.25,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.incomplete_circle_rounded,
                        size: 40,
                        color: Color.fromARGB(255, 255, 93, 52),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Pending Task",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            widget.allPending.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 23),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.07,
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.alarm,
                        color: Color.fromARGB(255, 255, 93, 52),
                        size: 30,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Reminders",
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      )
                    ],
                  ),
                  Switch(
                    value: reminder,
                    onChanged: ((value) {
                      reminder = value;
                      setState(() {});
                    }),
                    activeColor: const Color.fromARGB(255, 255, 93, 52),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 150,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Logging Out",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ));
                        });
                    await FirebaseAuth.instance.signOut().then((value) {
                      // pop the dialog
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const Welcome();
                      }));
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Log Out ",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
