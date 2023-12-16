import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/event_card.dart';

class Remainder extends StatefulWidget {
  const Remainder({super.key});

  @override
  State<Remainder> createState() => _RemainderState();
}

class _RemainderState extends State<Remainder> {
  List<String> userTaskDates = [];
  DateTime? calenderSelectedDate;
  List<String> tasksForSelectedDate = [];
  List<String> taskPriority = [];

  //funtion to fetch user tasks from firebase
  Future<void> fetchUserDates() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('task')
              .get();

      //extract the dates from the query snapshot
      querySnapshot.docs.forEach((doc) {
        userTaskDates.add(doc['taskDate']);
      });

      setState(() {});

      print(userTaskDates);
    } catch (e) {
      //print('Error fetching user dates' + e.toString());
    }
  }

  // Function to retrieve tasks for the selected date
  Future<void> fetchTasksForSelectedDate(DateTime selectedDate) async {
    try {
      // Convert selectedDate to a string in the format 'yyyy-MM-dd'
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

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

      setState(() {});

      print(tasksForSelectedDate);
    } catch (e) {
      //print('Error fetching tasks for selected date: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      appBar: AppBar(
        backgroundColor: Colours().primary,
        elevation: 0,
        title: Center(
          child: Text(
            'Upcoming Tasks',
            style: GoogleFonts.ubuntu(
              fontSize: 25,
              //fontWeight: FontWeight.bold,
              color: Colours().unSelectedText,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //showing the dates picked by the user for tasks
            DatePicker(
              DateTime.now().add(const Duration(days: 1)),
              height: 110,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colours().calenderFillColour,
              activeDates: [
                for (var date in userTaskDates) DateTime.parse(date)
              ],
              deactivatedColor: Colours().deActiveDateColour,
              monthTextStyle: GoogleFonts.ubuntu(
                fontSize: 14,
                //fontWeight: FontWeight.bold,
                color: Colours().selectedMonthColour,
              ),
              dateTextStyle: GoogleFonts.ubuntu(
                fontSize: 30,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
              dayTextStyle: GoogleFonts.ubuntu(
                fontSize: 14,
                //fontWeight: FontWeight.bold,
                color: Colours().selectedDateColour,
              ),
              onDateChange: (date) {
                setState(() {
                  calenderSelectedDate = date;
                  fetchTasksForSelectedDate(date);
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            //display selected date with the day
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text(
                calenderSelectedDate == null
                    ? 'No date selected'
                    : DateFormat('EEEE, d MMMM').format(calenderSelectedDate!),
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            //underline for the selected date
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Container(
                height: 1,
                width: 375,
                color: Colours().dateUnderline,
              ),
            ),
            //display tasks for the selected date in a list view if any or else display a message
            //if no dates has been selected then display no date has been selected
            calenderSelectedDate == null
                ? _emptyDate()
                : tasksForSelectedDate.isEmpty
                    ? _taskEmpty()
                    : _timeline(tasksForSelectedDate, taskPriority,
                        calenderSelectedDate!),
          ],
        ),
      ),
    );
  }
}

// return date line method for code simplicity
_timeline(List<String> tasksForSelectedDate, List<String> taskPriority,
    DateTime calenderSelectedDate) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22.0),
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
            //card creation
            endChild: EventCard(
              taskName: tasksForSelectedDate[index],
              taskPriority: taskPriority[index],
              selectedDate: calenderSelectedDate,
              isTaskDeleted: false,
            ),
          ),
        );
      },
    ),
  );
}

_taskEmpty() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22.0),
    child: Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Column(
        children: [
          // Center(
          //   child: Text(
          //     'No tasks for this date',
          //     style: GoogleFonts.ubuntu(
          //       fontSize: 22,
          //       //fontWeight: FontWeight.bold,
          //       color: Colours().unSelectedText,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 50,
              width: 200,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              //   border: Border.all(
              //     color: Colours().borderColor,
              //     width: 2,
              //   ),
              // ),
              child: Center(
                  // child: Text(
                  //   'Add a task',
                  //   style: GoogleFonts.ubuntu(
                  //     fontSize: 22,
                  //     //fontWeight: FontWeight.bold,
                  //     color: Colours().unSelectedText,
                  //   ),
                  // ),
                  ),
            ),
          ),
        ],
      ),
    ),
  );
}

_emptyDate() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22.0),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        // child: Text(
        //   'No date selected',
        //   style: GoogleFonts.ubuntu(
        //     fontSize: 22,
        //     //fontWeight: FontWeight.bold,
        //     color: Colours().unSelectedText,
        //   ),
        // ),
      ),
    ),
  );
}
