import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';

class NewTask extends StatefulWidget {
  var uid;
  NewTask(this.uid);
  @override
  State<NewTask> createState() => _NewTaskState(uid);
}

class _NewTaskState extends State<NewTask> {
  var uid;
  _NewTaskState(this.uid);
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    // set selectedDate like this so that tasks can be retrived by date by date
    selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    selectedTime = TimeOfDay.now();

    super.initState();
  }

  createNewTask() async {
    DateTime newDate = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
    if (title.text.isNotEmpty) {
      var task = {
        "uid": uid,
        "title": title.text,
        "description": description.text,
        "date": selectedDate.toString(),
        "time": selectedTime.format(context),
        "timestamp": Timestamp.fromDate(newDate),
        "done": false,
      };
      // show loading pop
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
                  "Creating...",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ));
          });
      await FirebaseFirestore.instance
          .collection("tasks")
          .add(task)
          .then((value) {
        setState(() {
          title.text = "";
          description.text = "";
        });
      }).then((value) {
        Navigator.of(context).pop();
      });
    }
    print(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color.fromARGB(255, 35, 39, 49),
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Taskoo',
                  style: TextStyle(
                      fontFamily: 'taskooFont',
                      color: Color.fromARGB(255, 255, 93, 52),
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Create\nNew Task",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Task title",
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: title,
              cursorColor: Colors.white12,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60))),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // container for date selector
                InkWell(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2025))
                        .then((value) {
                      try {
                        selectedDate = value!;
                      } catch (e) {
                        print(e);
                      }
                      setState(() {});
                    });
                  },
                  child: Container(
                    height: 101,
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 16, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.date_range,
                                color: Color.fromARGB(255, 255, 93, 52),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Date',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            formatDate(selectedDate, [dd, ' ', MM]).toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // container for time button
                InkWell(
                  onTap: () {
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) {
                      try {
                        selectedTime = value!;
                      } catch (e) {
                        print(e);
                      }
                      setState(() {});
                    });
                  },
                  child: Container(
                    height: 101,
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 16, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.timer,
                                color: Color.fromARGB(255, 255, 93, 52),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Time',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            selectedTime.format(context),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),

            // section for descripitions
            const Text(
              "Descriptions",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),

            TextField(
              inputFormatters: [
                // set description text limit at 150 words
                LengthLimitingTextInputFormatter(150),
              ],
              controller: description,
              cursorColor: Colors.white12,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                  hintText: "Optional",
                  hintStyle: const TextStyle(color: Colors.white60),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white30)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white30))),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                createNewTask();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 93, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "Create Task",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
