import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/screens/home/home.dart';
import 'package:taskoo/screens/new%20task/newtask.dart';
import 'package:taskoo/screens/profile/profile.dart';
import 'package:taskoo/screens/tasks/tasks.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class MainHome extends StatefulWidget {
  var uid;
  MainHome(this.uid, {super.key});
  @override
  // ignore: no_logic_in_create_state
  State<MainHome> createState() => _MainHomeState(uid);
}

class _MainHomeState extends State<MainHome> {
  var selectedIndex = 0;
  var uid;
  var allDone = 0;
  var allPending = 0;
  var pending = 0;

  //date stream for tasks to get real time update
  late Stream<QuerySnapshot> _tasksStream;
  late Stream<QuerySnapshot> _todaysTasksStream;
  //late Stream<QuerySnapshot> _allTasksStream;
  DateTime todaysDate = DateTime.now();
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String userName = "";
  List allTasks = <Map>[];
  List todaysTasks = <Map>[];

  _MainHomeState(this.uid);

  changeSelectedDate(date) {
    selectedDate = date;
    setState(() {});
  }

  getuserName() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where('userId', isEqualTo: uid)
        .get()
        .then((value) {
      userName = value.docs[0].data()["userName"].toString().capitalize();
      setState(() {});
    });
    // get done review tasks numbers
  }

// method for get selected date pending tasks
  getSelectedTasks(date) async {
    var i = 0;
    await FirebaseFirestore.instance
        .collection("tasks")
        .where("date", isEqualTo: date.toString())
        .where("uid", isEqualTo: uid.toString())
        .get()
        .then((value) {
      for (var task in value.docs) {
        if (task["done"]) {
        } else {
          i++;
        }
      }
    });
    pending = i;
    setState(() {});
  }

//method for get all pending tasks
  getAllTasks() async {
    await FirebaseFirestore.instance
        .collection("tasks")
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) {
      allTasks = value.docs;
      // fine done and pending tasks numbers
      for (var task in allTasks) {
        if (task["done"]) {
          allDone++;
        } else {
          allPending++;
        }
      }
    });

    // update on screen
    setState(() {});
  }

  updateTaskStream(date) async {
    // print('in getSelecteddate tesk');

    // await FirebaseFirestore.instance
    //     .collection("tasks")
    //     .where("uid", isEqualTo: uid)
    //     .where("date", isEqualTo: date.toString())
    //     .orderBy("timestamp", descending: false)
    //     .get()
    //     .then((value) {
    //   setState(() {
    //     // update selected date so calendertimeliner start from selected date even after setstate()
    //     dateTasks = value.docs;
    //     selectedDate = date;
    //   });
    //   // print(value.docs);
    // });
    _tasksStream = FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .where('date', isEqualTo: date.toString())
        .orderBy('timestamp', descending: false)
        .snapshots();
    selectedDate = date;
    setState(() {});
  }

  getTodaysTasks() async {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    await FirebaseFirestore.instance
        .collection("tasks")
        .where("uid", isEqualTo: uid)
        .where("date", isEqualTo: today.toString())
        .orderBy("timestamp", descending: false)
        .get()
        .then((value) {
      // print(value.docs);
      setState(() {
        todaysTasks = value.docs;
        // dateTasks = value.docs;
      });

      // print(value.docs);
    });
  }

  @override
  void initState() {
    // _allTasksStream = FirebaseFirestore.instance
    //     .collection('tasks')
    //     .where('uid', isEqualTo: uid)
    //     .snapshots();

    // set dataStream for selected date tasks
    _tasksStream = FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .where('date', isEqualTo: selectedDate.toString())
        .orderBy('timestamp', descending: false)
        .snapshots();

    // set data Stream for todays date tasks
    _todaysTasksStream = FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .where('date',
            isEqualTo:
                DateTime(todaysDate.year, todaysDate.month, todaysDate.day)
                    .toString())
        .orderBy('timestamp', descending: false)
        .snapshots();
    //this is for home
    getSelectedTasks(
        DateTime(todaysDate.year, todaysDate.month, todaysDate.day));
    getuserName();
    getAllTasks();
    getTodaysTasks();

    super.initState();
  }

  // ignore: non_constant_identifier_names
  Widget Body() {
    if (selectedIndex == 0) {
      return Home(userName, _todaysTasksStream, allDone, allPending);
    } else if (selectedIndex == 1) {
      return Tasks(_tasksStream);
    } else if (selectedIndex == 2) {
      return NewTask(uid);
    } else if (selectedIndex == 3) {
      return Profile(userName, allDone, allPending);
    } else {
      return Home(userName, _todaysTasksStream, allDone, allPending);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedIndex == 1
          ? AppBar(
              toolbarHeight: 270,
              title: Column(
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
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(selectedDate, [MM, ' ', dd]).toString(),
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            pending > 1
                                ? "$pending tasks pending"
                                : "$pending task pending",
                            style: const TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Container(
                        height: 45,
                        width: 44,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 255, 93, 52)),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CalendarTimeline(
                    initialDate: selectedDate,
                    firstDate: DateTime(2023, 1, 26),
                    lastDate: DateTime(2023, 12, 31),
                    onDateSelected: (date) =>
                        {updateTaskStream(date), getSelectedTasks(date)},
                    monthColor: Colors.white,
                    dayColor: Colors.white,
                    activeDayColor: Colors.white,
                    activeBackgroundDayColor:
                        const Color.fromARGB(255, 255, 93, 52),
                  ),
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 35, 39, 49),
            )
          : null,
      body: Body(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 255, 93, 52),
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color.fromARGB(255, 35, 39, 49),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note_sharp), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_comment_sharp), label: "New Task"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Account"),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications),
          //   label: "Notifications",
          // ),
        ],
      ),
    );
  }
}
