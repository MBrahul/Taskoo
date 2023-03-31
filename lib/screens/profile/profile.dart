import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/screens/auth/login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class Profile extends StatefulWidget {
  final Function() updateParent;
  String username;
  String imageUrl;
  String userDocId;
  var allDone;
  var allPending;

  Profile(this.username, this.imageUrl, this.userDocId, this.allDone,
      this.allPending, this.updateParent,
      {super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool reminder = false;
  late File image;

  getImage(String source) async {
    ImageSource s;
    if (source == "camera") {
      s = ImageSource.camera;
    } else {
      s = ImageSource.gallery;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    try {
      final ImagePicker picker = ImagePicker();
      XFile? file = await picker.pickImage(source: s);
      // print(file!.path.toString());

      // upload image to firebase storage
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      //create a reference to the image
      Reference referenceImageToUpload =
          referenceDirImages.child(DateTime.now().toString());
      // show loading dialog
      if (file != null) {
        showDialog(
            context: context,
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Updating Profile Picture",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  )
                ],
              );
            });
        final value = await referenceImageToUpload.putFile(File(file!.path));

        String imageUrl = await referenceImageToUpload.getDownloadURL();
        widget.updateParent();
        Navigator.pop(context);
        //  print("updating user with ${widget.userDocId}");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userDocId)
            .update({"imageUrl": imageUrl});
      }
    } catch (e) {
      print(e);
    }
  }

  showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color.fromARGB(255, 35, 39, 49),
        duration: const Duration(minutes: 10),
        content: SizedBox(
          height: 164,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getImage("camera");
                      },
                      child: const Text(
                        "Take Photo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    InkWell(
                      onTap: () {
                        getImage("gallery");
                      },
                      child: const Text(
                        "Choose Photo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20)),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: const Text(
                    "Cancel",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 35, 39, 49),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                      color: Colors.white70, spreadRadius: 0, blurRadius: 0.0)
                ], borderRadius: BorderRadius.circular(105)),
                child: widget.imageUrl.isEmpty
                    ? InkWell(
                        onTap: () {
                          showSnackBar();
                        },
                        child: const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.black,
                          size: 120,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          showSnackBar();
                        },
                        child: Container(
                          decoration: BoxDecoration(boxShadow: const [
                            BoxShadow(
                                color: Colors.white,
                                spreadRadius: 1.0,
                                blurRadius: 5.0)
                          ], borderRadius: BorderRadius.circular(105)),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.imageUrl),
                            radius: 60,
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.username,
                style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
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
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
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
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
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
                          Icons.track_changes_outlined,
                          color: Color.fromARGB(255, 255, 93, 52),
                          size: 30,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Success Rate",
                          style: TextStyle(color: Colors.white, fontSize: 21),
                        )
                      ],
                    ),
                    // Switch(
                    //   value: reminder,
                    //   onChanged: ((value) {
                    //     reminder = value;
                    //     setState(() {});
                    //   }),
                    //   activeColor: const Color.fromARGB(255, 255, 93, 52),
                    // )
                    Text(
                      (widget.allDone + widget.allPending) != 0
                          ? '${(widget.allDone * 100 / (widget.allDone + widget.allPending)).toStringAsFixed(2)}%'
                          : "0.0%",
                      style: const TextStyle(color: Colors.white, fontSize: 21),
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
                          return Login();
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
      ),
    );
  }
}
