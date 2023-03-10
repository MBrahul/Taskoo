import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/custom%20widgets/task.dart';

class Tasks extends StatefulWidget {
  // List dateTasks = <Map>[];
  final Stream<QuerySnapshot> _tasksStream;
  // var uid;
  // String selectedDate;
  Tasks(this._tasksStream, {super.key});
  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  _TasksState();

  Widget taskListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget._tasksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          // print(snapshot.error);
          return const Center(
              child: Text(
            'Something went wrong',
            style: TextStyle(color: Colors.white70),
          ));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Text(
            "Loading....",
            style: TextStyle(color: Colors.white70),
          ));
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No task found! 🧐',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70),
            ),
          );
        }
        // print(snapshot.data!.docs);
        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                // get id for deleting task
                var id = document.id;
                // print(id);
                return Column(
                  children: [
                    Task(
                        data["title"],
                        data["description"],
                        MediaQuery.of(context).size.width / 1.12,
                        data["time"],
                        data["date"],
                        id,
                        data["done"],
                        context),
                    const SizedBox(
                      height: 15,
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
      height: double.infinity,
      width: double.infinity,
      color: const Color.fromARGB(255, 35, 39, 49),
      child: Padding(
          padding: const EdgeInsets.only(top: 10.0), child: taskListView()),
    );
  }
}
