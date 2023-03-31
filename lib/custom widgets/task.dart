import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget Task(String title, String description, double width, String time,
    String date, var id, bool done, var context, final Function() updateTask) {
  var parsedDate = DateTime.parse(date);
  void deleteNote(id) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(id)
          .delete()
          .then((value) {
        // print("task deleted successfully");
      }).catchError((e) {
        // print(e);
      });
      updateTask();
    } catch (e) {}
  }

  final date2 = DateTime.now();
  final dayRemaining = parsedDate.difference(date2).inDays;
  return InkWell(
    onTap: () {
      // print("clicked on task");
      if (description.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          dismissDirection: DismissDirection.down,
          content: Stack(children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 35, 39, 49),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          description.length >= 149
                              ? '${description.substring(0, 150)}..'
                              : description,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white70),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Positioned(
                right: 10,
                top: 80,
                child: Icon(
                  Icons.arrow_downward_sharp,
                  size: 40,
                  color: Color.fromARGB(255, 255, 93, 52),
                ))
          ]),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
        ));
      }
    },
    child: Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.length > 20 ? "${title.substring(0, 20)}.." : title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 93, 52),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, right: 10, left: 10),
                    child: Text(
                      dayRemaining >= 0 ? "${dayRemaining}d" : "Expired",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.watch_later_rounded,
                  size: 30,
                  color: Color.fromARGB(255, 255, 93, 52),
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            !done
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            //delete the task
                            // print("deleting data with id $id");
                            deleteNote(id);
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            size: 35,
                            // color: Color.fromARGB(255, 255, 93, 52),
                            color: Colors.amber,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(id)
                                  .update({
                                "done": true,
                                "pending": false
                              }).then((value) {
                                // print("Task updated successfully");
                              });
                              updateTask();
                            } catch (e) {}
                          },
                          icon: const Icon(
                            Icons.done_outline_outlined,
                            size: 35,
                            // color: Color.fromARGB(255, 255, 93, 52),
                            color: Colors.green,
                          )),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Status:",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  )
          ],
        ),
      ),
    ),
  );
}
