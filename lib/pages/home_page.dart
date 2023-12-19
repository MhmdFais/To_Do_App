import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variable to store user first name and email
  String firstName = '';
  String? email;
  List<String> tasks = [];
  List<String> taskPriority = [];
  List<String> taskDetails = [];
  bool isDeleted = false;
  void Function()? onTap;

  //get user first name from firebase
  Future<void> getUserFirstName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user!.uid;
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      firstName = userDoc.data()!['firstName'];
      email = user.email;
    });
  }

  //retrieve tasks for today from firebase
  Future<void> fetchTasksForToday() async {
    String formattedDate = DateTime.now().toString().substring(0, 10);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('task')
              .where('taskDate', isEqualTo: formattedDate)
              .get();

      //Extract the task names
      tasks =
          querySnapshot.docs.map((doc) => doc['taskName'] as String).toList();

      //Extract the task priority
      taskPriority = querySnapshot.docs
          .map((doc) => doc['taskPriority'] as String)
          .toList();

      //Extract the task details
      taskDetails = querySnapshot.docs
          .map((doc) => doc['taskDetails'] as String)
          .toList();
    } catch (e) {
      print('fetchTasksForToday error: $e');
    }
  }

  //container for each task
  taskContainer(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colours().containerColour,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colours().buttonShadow,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  decoration: BoxDecoration(
                    color: taskPriority[index] == 'High'
                        ? Colours().highPriority
                        : taskPriority[index] == 'Medium'
                            ? Colours().mediumPriority
                            : Colours().lowPriority,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colours().primary,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colours().taskCradIconColour,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tasks[index],
                        style: GoogleFonts.ubuntu(
                          fontSize: 22,
                          //fontWeight: FontWeight.bold,
                          color: Colours().unSelectedText,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${taskPriority[index]} Priority',
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                          color: Colours().unSelectedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                showTaskDetails(index);
              },
              icon: const Icon(
                Icons.more_vert,
                size: 35,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //show task details
  void showTaskDetails(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Center(
              child: Text(
                tasks[index],
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  'Task Priority',
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colours().unSelectedText,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  height: 40,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colours().borderColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      taskPriority[index],
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        color: Colours().unSelectedText,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Text(
                  'Task Details',
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colours().unSelectedText,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  height: 320,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colours().borderColor,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      taskDetails[index],
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        color: Colours().unSelectedText,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colours().borderColor,
                      width: 1,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
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
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //getUserFirstName();
    fetchTasksForToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      appBar: AppBar(
        backgroundColor: Colours().primary,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Hello!',
              style: GoogleFonts.pacifico(
                fontSize: 25,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              firstName,
              style: GoogleFonts.pacifico(
                fontSize: 25,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'What do you',
              style: GoogleFonts.ubuntu(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            Text(
              'like to do today?',
              style: GoogleFonts.ubuntu(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            Text(
              'Set tasks according to your priority',
              style: GoogleFonts.ubuntu(
                fontSize: 16,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text(
              'Today\'s Tasks',
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                color: Colours().unSelectedText,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            //tasks for today in a list view
            FutureBuilder(
              future: fetchTasksForToday(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return taskContainer(index);
                    },
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
