import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/custom%20widgets/task.dart';

class Home extends StatefulWidget {
  String userName;
  List allTasks = <Map>[];
  final Stream<QuerySnapshot> _todaysTasksStream;
  var done;
  var pending;

  Home(this.userName, this._todaysTasksStream, this.done, this.pending,
      {super.key}) {
    //
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todaysTasks = <Map>[];

  Widget taskListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget._todaysTasksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(
              child: Text(
            'Something went wrong',
            style: TextStyle(color: Colors.white70),
          ));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  Text("Loading....", style: TextStyle(color: Colors.white70)));
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text(
            'No task found! 🧐',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.white70),
          );
        }
        // print(snapshot.data!.docs);
        return ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                // get id for deleting task
                var id = document.id;
                // print(id);
                return Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Task(
                        data["title"],
                        data["description"],
                        MediaQuery.of(context).size.width / 1.20,
                        data["time"],
                        data["date"],
                        id,
                        data["done"],
                        context),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 35, 39, 49),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // row for user name and profile logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hii ${widget.userName}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "${widget.pending} tasks pending",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 93, 52)),
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: const Color.fromARGB(255, 255, 93, 52))),
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 35, 39, 49),
                      radius: 27.00,
                      backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPDxExA79GMgWNjwLYOMbd6eLMqwTJCtHd3_EAKm-9pitWIl78GvX_QisowoXPLfmJ6GT6nJ8zODc&usqp=CAU&ec=48600113",
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              // row for search bar and search button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.white30,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color.fromARGB(255, 255, 93, 52),
                            size: 30,
                          ),
                          hintText: "Search by title ....",
                          hintStyle: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w300,
                              fontSize: 17),
                          filled: true,
                          fillColor: Colors.white10,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 255, 93, 52)))),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              // overview section

              const Text(
                "Overview",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 23,
              ),
              SizedBox(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20)),
                        width: MediaQuery.of(context).size.width / 2.4,
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Total Tasks",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                (widget.done + widget.pending).toString(),
                                style: const TextStyle(
                                    fontSize: 50, color: Colors.white54),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20)),
                        height: 180,
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Done",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.done.toString(),
                                style: const TextStyle(
                                    fontSize: 50, color: Colors.white54),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(20)),
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Waiting For Review",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.pending.toString(),
                                style: const TextStyle(
                                    fontSize: 50, color: Colors.white54),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
              const SizedBox(
                height: 25,
              ),

              // today's task section

              const Text(
                "Today's Tasks",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(height: 180, child: taskListView())
            ],
          ),
        ),
      ),
    );
  }
}
