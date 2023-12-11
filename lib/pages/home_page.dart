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
  bool _isMounted = false;

  //get user first name from firebase
  Future getUserFirstName() async {
    email = FirebaseAuth.instance.currentUser!.email;
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (_isMounted) {
      setState(() {
        firstName = result.docs[0].get('firstName');
      });
    }
  }

  @override
  void dispose() {
    _isMounted = false; // Widget is being disposed
    super.dispose();
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
              'Running Tasks',
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                color: Colours().unSelectedText,
                fontWeight: FontWeight.bold,
              ),
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
