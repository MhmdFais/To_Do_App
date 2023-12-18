import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:to_do/components/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  List<String> taskDetails = [];
  final taskNameEdit = TextEditingController();
  final taskDetailsEdit = TextEditingController();
  int? selectedPriorityIndex;
  String? taskPriorityString;

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

      print('User dates are: $userTaskDates');
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

      // Extract the task details from the query snapshot
      taskDetails = querySnapshot.docs
          .map((doc) => doc['taskDetails'] as String)
          .toList();

      setState(() {});

      print('Tasks for selected date are: $tasksForSelectedDate');
    } catch (e) {
      //print('Error fetching tasks for selected date: $e');
    }
  }

  //endcard child
  endCard(int index) {
    return Padding(
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
                      tasksForSelectedDate[index],
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
                      onTap: () => showTaskDetails(tasksForSelectedDate[index],
                          taskDetails[index], taskPriority[index]),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 15),
                    //delete icon
                    GestureDetector(
                      onTap: () => delteConfirmMessadeBox(
                          tasksForSelectedDate[index], taskPriority[index]),
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
    );
  }

  //delete conformation alert dialog
  void delteConfirmMessadeBox(String taskName, String taskPriority) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Task',
            style: GoogleFonts.ubuntu(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colours().unSelectedText,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this task?',
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              //fontWeight: FontWeight.bold,
              color: Colours().unSelectedText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.ubuntu(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
            ),
            Container(
              height: 45,
              width: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colours().deleteTextColour,
              ),
              child: TextButton(
                onPressed: () {
                  deleteTask(taskName, taskPriority);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Delete',
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colours().primary,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //fuction to delete the particluar task
  void deleteTask(String taskName, String taskPriority) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('task')
          .where('taskName', isEqualTo: taskName)
          .where('taskPriority', isEqualTo: taskPriority)
          .where('taskDate',
              isEqualTo: calenderSelectedDate.toString().substring(0, 10))
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      //fetching the updated tasks
      fetchTasksForSelectedDate(calenderSelectedDate!);

      print('Task deleted successfully');
    } catch (e) {
      print('delete task error' + e.toString());
    }
  }

  //task details when edit button is pressed
  void showTaskDetails(
      String taskName, String taskDetails, String taskPriority) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            //backgroundColor: Colours().alerDialogColour,
            title: Center(
              child: Center(
                child: Text(
                  taskName,
                  style: GoogleFonts.ubuntu(
                    fontSize: 22,
                    //fontWeight: FontWeight.bold,
                    color: Colours().unSelectedText,
                  ),
                ),
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                //task name
                Text(
                  'Task Name',
                  style: GoogleFonts.ubuntu(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                    color: Colours().taskRoundMarkLine,
                  ),
                ),
                const SizedBox(height: 10),
                //text field for task name
                SizedBox(
                  width: 500,
                  child: TextField(
                    controller: taskNameEdit,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 25,
                    //initialValue: widget.taskName,
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      color: Colours().unSelectedText,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colours().alertTextRoundColour,
                        ),
                      ),
                      hintText: 'Give a new name for task',
                      hintStyle: GoogleFonts.ubuntu(
                        fontSize: 18,
                        //fontWeight: FontWeight.bold,
                        color: Colours().alertHintTextColour,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),
                //task priority
                const SizedBox(height: 20),
                Text(
                  'Task Priority',
                  style: GoogleFonts.ubuntu(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                    color: Colours().taskRoundMarkLine,
                  ),
                ),
                const SizedBox(height: 10),
                //priority dropdown
                ToggleSwitch(
                  minWidth: 92,
                  cornerRadius: 20,
                  borderColor: [
                    Colours().alertTextRoundColour,
                    Colours().alertTextRoundColour,
                    Colours().alertTextRoundColour
                  ],
                  dividerColor: Colours().alertTextRoundColour,
                  borderWidth: 1,
                  fontSize: 16,
                  initialLabelIndex: selectedPriorityIndex,
                  inactiveBgColor: Colors.grey.shade300,
                  activeFgColor: Colors.white,
                  totalSwitches: 3,
                  labels: const ['High', 'Medium', 'Low'],
                  onToggle: (index) {
                    setState(() {
                      selectedPriorityIndex = index!;
                    });
                    prioritySwitchedTo(selectedPriorityIndex!);
                    print('switched to: $selectedPriorityIndex');
                  },
                ),
                const SizedBox(height: 40),
                //task details text field
                Text(
                  'Task Details',
                  style: GoogleFonts.ubuntu(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                    color: Colours().taskRoundMarkLine,
                  ),
                ),
                const SizedBox(height: 10),
                //text field for task details
                SizedBox(
                  width: 500,
                  child: TextField(
                    controller: taskDetailsEdit,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 100,
                    //initialValue: widget.taskDetails,
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      color: Colours().unSelectedText,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colours().alertTextRoundColour,
                        ),
                      ),
                      hintText: taskDetails,
                      hintStyle: GoogleFonts.ubuntu(
                        fontSize: 18,
                        //fontWeight: FontWeight.bold,
                        color: Colours().alertHintTextColour,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  taskNameEdit.clear();
                  taskDetailsEdit.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colours().unSelectedText,
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colours().alerEditButtonColour,
                ),
                child: TextButton(
                  onPressed: () {
                    updateTask(taskNameEdit.text, taskDetailsEdit.text,
                        taskName, taskPriority);
                    taskNameEdit.clear();
                    taskDetailsEdit.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Update',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      color: Colours().unSelectedText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //task priority switched to
  void prioritySwitchedTo(int priority) async {
    if (priority == 0) {
      taskPriorityString = 'High';
    } else if (priority == 1) {
      taskPriorityString = 'Medium';
    } else {
      taskPriorityString = 'Low';
    }

    print('priority switched to: $taskPriorityString');
  }

  //function to update the task
  void updateTask(String newTaskName, String newTaskDetails, String taskName,
      String taskPriority) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('task')
          .where('taskName', isEqualTo: taskName)
          .where('taskPriority', isEqualTo: taskPriority)
          .where('taskDate',
              isEqualTo: calenderSelectedDate.toString().substring(0, 10))
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'taskName': newTaskName,
            'taskPriority': taskPriorityString,
            'taskDetails': newTaskDetails,
          });
        });
      });

      //fetching the updated tasks
      fetchTasksForSelectedDate(calenderSelectedDate!);

      print('Task updated successfully');
    } catch (e) {
      print('update task error' + e.toString());
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
              // activeDates: [
              //   for (var date in userTaskDates) DateTime.parse(date)
              // ],
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
                  print(
                      'Selected date in inner calender: $calenderSelectedDate');
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
                ? Padding(
                    padding: const EdgeInsets.only(left: 22.0, top: 20),
                    child: Text(
                      '',
                      style: GoogleFonts.ubuntu(
                        fontSize: 22,
                        //fontWeight: FontWeight.bold,
                        color: Colours().unSelectedText,
                      ),
                    ),
                  )
                : tasksForSelectedDate.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22.0, top: 120),
                          child: Text(
                            '',
                            style: GoogleFonts.ubuntu(
                              fontSize: 22,
                              //fontWeight: FontWeight.bold,
                              color: Colours().unSelectedText,
                            ),
                          ),
                        ),
                      )
                    : //circular indicatore while retreiving
                    Padding(
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
                                isLast:
                                    index == tasksForSelectedDate.length - 1,
                                endChild: endCard(index),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
