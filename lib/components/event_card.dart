import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EventCard extends StatefulWidget {
  final String taskName;
  final String taskPriority;
  //final String taskDetails;
  final DateTime selectedDate;
  final bool isTaskDeleted;

  const EventCard(
      {super.key,
      required this.taskName,
      required this.taskPriority,
      //required this.taskDetails,
      required this.selectedDate,
      required this.isTaskDeleted});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  List<String> taskDetails = [];
  final taskNameEdit = TextEditingController();
  final taskDetailsEdit = TextEditingController();
  String selectedPriority = '';
  int? selectedPriorityIndex;
  String? switchedPriorityTo = '';

  //function to handle delete icon
  void delteConfirmMessadeBox() {
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
                  deleteTask();
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

  //delete the selected task from firestore
  void deleteTask() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('task')
          .where('taskName', isEqualTo: widget.taskName)
          .where('taskPriority', isEqualTo: widget.taskPriority)
          .where('taskDate',
              isEqualTo: widget.selectedDate.toString().substring(0, 10))
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      print('task deleted');
    } catch (e) {
      print('error deleting task + $e');
    }
  }

  //get the taskDetails for the selected task
  Future<void> fetchTaskDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('task')
          .where('taskName', isEqualTo: widget.taskName)
          .where('taskPriority', isEqualTo: widget.taskPriority)
          .where('taskDate',
              isEqualTo: widget.selectedDate.toString().substring(0, 10))
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          taskDetails.add(doc['taskDetails']);
        });
      });

      print('task details fetched');
    } catch (e) {
      print('error fetching task details + $e');
    }
  }

  void setPriorityIndex() {
    if (widget.taskPriority == 'High') {
      selectedPriorityIndex = 0;
    } else if (widget.taskPriority == 'Medium') {
      selectedPriorityIndex = 1;
    } else {
      selectedPriorityIndex = 2;
    }

    print('before edit: $selectedPriorityIndex');
  }

  void switchPriority(int selectedPriorityIndex) {
    if (selectedPriorityIndex == 0) {
      switchedPriorityTo = 'High';
    } else if (selectedPriorityIndex == 1) {
      switchedPriorityTo = 'Medium';
    } else {
      switchedPriorityTo = 'Low';
    }

    print('after edit in method: $switchedPriorityTo');
  }

  //update the task details in firestore
  void updateTaskDetailsInFirestre() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('task')
          .where('taskName', isEqualTo: widget.taskName)
          .where('taskPriority', isEqualTo: widget.taskPriority)
          .where('taskDate',
              isEqualTo: widget.selectedDate.toString().substring(0, 10))
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'taskName': taskNameEdit.text,
            'taskPriority': switchedPriorityTo,
            'taskDetails': taskDetailsEdit.text,
          });
        });
      });

      print('task details updated');
    } catch (e) {
      print('error updating task details + $e');
    }
  }

  //show task details and edit those if user needed when edit icon is pressed
  void showTaskDetails() {
    //taskNameEdit.text = widget.taskName;
    //taskDetailsEdit.text = taskDetails.isNotEmpty ? taskDetails[0] : '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            //backgroundColor: Colours().alerDialogColour,
            title: Center(
              child: Center(
                child: Text(
                  '${widget.taskName}',
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
                    switchPriority(selectedPriorityIndex!);
                    //print('switched to: $selectedPriority');
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
                      hintText: 'Give a new task description',
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
                  Navigator.of(context).pop();
                  //clear the text field
                  taskNameEdit.clear();
                  taskDetailsEdit.clear();
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
                    updateTaskDetailsInFirestre();
                    Navigator.of(context).pop();
                    taskDetailsEdit.clear();
                    taskNameEdit.clear();
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

  @override
  void initState() {
    super.initState();
    //deleteTask();
    fetchTaskDetails();
    setPriorityIndex();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    color: widget.taskPriority == 'High'
                        ? Colours().highPriority
                        : widget.taskPriority == 'Medium'
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
                        widget.taskName,
                        style: GoogleFonts.ubuntu(
                          fontSize: 22,
                          //fontWeight: FontWeight.bold,
                          color: Colours().unSelectedText,
                        ),
                      ),
                      const SizedBox(height: 5),
                      //priority
                      Text(
                        '${widget.taskPriority} Priority',
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
                        onTap: showTaskDetails,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 15),
                      //delete icon
                      GestureDetector(
                        onTap: delteConfirmMessadeBox,
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
    );
  }
}
