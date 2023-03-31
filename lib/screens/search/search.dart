import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/custom%20widgets/task.dart';

class Search extends StatelessWidget {
  String title;
  List searchedTasks = [];
  final Function() updateParent;
  final Stream<QuerySnapshot> _tasksStream;
  Search(this.title, this._tasksStream, this.updateParent, {super.key});
  Widget taskListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksStream,
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
                        context,
                        updateParent),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 39, 49),
        title: Text(
          "Search results for '$title'",
        ),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromARGB(255, 35, 39, 49),
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20.0), child: taskListView()),
          )),
    );
  }
}
