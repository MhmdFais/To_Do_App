import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:to_do/components/colors.dart';

class EventCard extends StatefulWidget {
  final DateTime selectedDate;

  const EventCard({
    required this.selectedDate,
    super.key,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  List<String> tasksForSelectedDate = [];
  List<String> taskPriority = [];
  String? taskPriorityString;

  //Method to fetch the tasks for the selected date
  Future<void> fetchTasksForSelectedDate() async {
    try {
      // Convert selectedDate to a string in the format 'yyyy-MM-dd'
      String formattedDate =
          "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('task')
              .where('taskDate', isEqualTo: formattedDate)
              .get();

      // Extract the tasks from the query snapshot
      tasksForSelectedDate =
          querySnapshot.docs.map((doc) => doc['taskName'] as String).toList();

      // Extract the task priority from the query snapshot
      taskPriority = querySnapshot.docs
          .map((doc) => doc['taskPriority'] as String)
          .toList();

      print(taskPriorityString);

      setState(() {});

      print('Tasks for selected date are: $tasksForSelectedDate');
      print('TaskPriority for selected date are: $taskPriority');
    } catch (e) {
      print('Error fetching tasks for selected date' + e.toString());
    }
  }

  @override
  void initState() {
    fetchTasksForSelectedDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //timeline tile and event card
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasksForSelectedDate.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            //timeline creation
            child: TimelineTile(
              alignment: TimelineAlign.start,
              beforeLineStyle: LineStyle(
                color: Colours().taskLineColor,
                thickness: 3,
              ),
              indicatorStyle: IndicatorStyle(
                color: Colours().taskLineColor,
              ),
              lineXY: 0.2,
              isFirst: index == 0,
              isLast: index == tasksForSelectedDate.length - 1,
              endChild: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colours().primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colours().buttonShadow,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          //priority color
                          Container(
                            height: 50,
                            width: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: taskPriority[index] == 'High'
                                  ? Colours().highPriority
                                  : taskPriority[index] == 'Medium'
                                      ? Colours().mediumPriority
                                      : Colours().lowPriority,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${tasksForSelectedDate[index]}',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 22,
                                    //fontWeight: FontWeight.bold,
                                    color: Colours().unSelectedText,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                //priority
                                Text(
                                  '${taskPriority[index]} Priority',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                    color: Colours().unSelectedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //icons for edit and delete
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Row(
                              children: [
                                //edit icon
                                GestureDetector(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                //delete icon
                                GestureDetector(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
