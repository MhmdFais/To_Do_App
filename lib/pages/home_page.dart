import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/pages/addTask_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variable to store user first name and email
  String firstName = '';
  String? email;

  //get user first name from firebase
  Future getUserFirstName() async {
    email = FirebaseAuth.instance.currentUser!.email;
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    setState(() {
      firstName = result.docs[0].get('firstName');
    });
  }

  @override
  void initState() {
    super.initState();
    getUserFirstName();
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
                fontSize: 30,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              firstName,
              style: GoogleFonts.ubuntu(
                fontSize: 30,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const AddTask();
                  }),
                );
              },
              text: 'Add Task',
            ),
          ],
        ),
      ),
    );
  }
}
