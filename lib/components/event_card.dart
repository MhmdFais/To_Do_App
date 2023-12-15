import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class EventCard extends StatefulWidget {
  final String taskName;
  final String taskPriority;
  //final String taskDetails;
  final DateTime selectedDate;

  const EventCard({
    super.key,
    required this.taskName,
    required this.taskPriority,
    //required this.taskDetails,
    required this.selectedDate,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  List<String> taskDetails = [];

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

  @override
  void initState() {
    super.initState();
    //deleteTask();
    fetchTaskDetails();
  }

  @override
  Widget build(BuildContext context) {
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
                      onTap: () {},
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
    );
  }
}
