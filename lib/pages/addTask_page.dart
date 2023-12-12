import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  int index = 0;
  String selectedPriority = 'High';
  final taskNameController = TextEditingController();
  final taskDetailController = TextEditingController();
  late DateTime datePicked = DateTime.now();

  void showDatePickerForUser() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((pickedDate) {
      setState(() {
        datePicked = pickedDate!;
      });
      print('$datePicked'.toString().substring(0, 10));
    });
  }

  //store priority according to the toggle switch
  void priority() {
    if (index == 0) {
      selectedPriority = 'High';
    } else if (index == 1) {
      selectedPriority = 'Medium';
    } else if (index == 2) {
      selectedPriority = 'Low';
    }
  }

  //add the task to the database and show a message that the task has been added
  void addTaskToDatabase() async {
    //if the task name is empty, show a message
    if (taskNameController.text.isEmpty) {
      messageAlerts('Task name is empty', 'Please enter a task name');
    } else {
      //if the task name is not empty, add the task to the database
      //add details to task collection in user colection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('task')
          .add({
        'taskName': taskNameController.text,
        'taskPriority': selectedPriority,
        'taskDetails': taskDetailController.text,
        'taskDate': datePicked.toString().substring(0, 10),
        'taskStatus': false,
      });

      //and show a message that the task has been added
      messageAlerts('Task added', 'Your task has been added');

      //if added successfully, clear the text fields
      taskNameController.clear();
      taskDetailController.clear();
      index = 0;
      datePicked = DateTime.now();
    }
  }

  //message to show
  void messageAlerts(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.ubuntu(
              fontSize: 25,
              //fontWeight: FontWeight.bold,
              color: Colours().unSelectedText,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              //fontWeight: FontWeight.bold,
              color: Colours().unSelectedText,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
                child: Text(
                  'Add a new task!',
                  style: GoogleFonts.ubuntu(
                    fontSize: 25,
                    //fontWeight: FontWeight.bold,
                    color: Colours().unSelectedText,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              //add task name
              Text(
                'Task name',
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              //text field for task name
              TextField(
                controller: taskNameController,
                obscureText: false,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorHeight: 24,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black87,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: 'Give task a name',
                  hintStyle: GoogleFonts.ubuntu(
                    fontSize: 18,
                  ),
                  counterStyle: GoogleFonts.ubuntu(
                    fontSize: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              //select priority
              Text(
                'Set priority',
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              //toggle for selecting priority
              ToggleSwitch(
                minWidth: 120.0,
                //minHeight: MediaQuery.of(context).size.height * 0.05,
                cornerRadius: 20.0,
                activeBgColors: const [
                  [Color.fromARGB(255, 245, 128, 128)],
                  [Color.fromARGB(255, 223, 223, 119)],
                  [Colors.greenAccent]
                ],
                activeFgColor: Colours().selectedText,
                inactiveBgColor: Colors.grey.shade300,
                inactiveFgColor: Colours().unSelectedText,
                initialLabelIndex: index,
                totalSwitches: 3,
                labels: const ['High', 'Medium', 'Low'],
                radiusStyle: true,
                fontSize: 18,
                onToggle: (index) {
                  setState(() {
                    this.index = index!;
                    priority();
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              //extended task details
              Text(
                'Task details',
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              //text field for task details
              TextField(
                controller: taskDetailController,
                obscureText: false,
                maxLength: 100,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorHeight: 24,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black87,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Add task details',
                  hintStyle: GoogleFonts.ubuntu(
                    fontSize: 18,
                  ),
                  counterStyle: GoogleFonts.ubuntu(
                    fontSize: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              //pick date
              Text(
                'Pick date',
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              //date picker
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colours().borderColor,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        datePicked.toString().substring(0, 10),
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                          color: Colours().unSelectedText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          showDatePickerForUser();
                        },
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              //add task button
              GestureDetector(
                onTap: addTaskToDatabase,
                child: Container(
                  height: 52,
                  width: 400,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 173, 80),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Save task',
                        style: GoogleFonts.ubuntu(
                          fontSize: 25,
                          //fontWeight: FontWeight.bold,
                          color: Colours().selectedText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
