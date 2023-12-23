import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  String firstName = '';
  String lastName = '';
  String newFirstName = '';
  String newLastName = '';

  Future<void> getFirstName() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      setState(() {
        firstName = querySnapshot.docs[0]['firstName'];
      });

      setState(() {
        lastName = querySnapshot.docs[0]['lastName'];
      });

      print('First Name setting page: $firstName');
      print('Last Name setting pge: $lastName');
    } catch (e) {
      print('Error: $e');
    }
  }

  //Edit first name nd last name
  void editMessageBox(String task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit $task',
            style: GoogleFonts.ubuntu(
              fontSize: 25,
              color: Colours().unSelectedText,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter $task',
              hintStyle: GoogleFonts.ubuntu(
                fontSize: 20,
                color: Colours().unSelectedText,
              ),
            ),
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              color: Colours().unSelectedText,
            ),
            onChanged: (value) {
              if (task == 'First Name') {
                setState(() {
                  newFirstName = value;
                });
              } else {
                setState(() {
                  newLastName = value;
                });
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  color: Colours().unSelectedText,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (task == 'First Name') {
                  updateFirstName(newFirstName);
                } else {
                  updateLastName(newLastName);
                }
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  color: Colours().unSelectedText,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //update first name and
  Future<void> updateFirstName(String name) async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({'firstName': name});
        });
      });
      getFirstName();
    } catch (e) {
      print('Error: $e');
    }
  }

  //update last name
  Future<void> updateLastName(String name) async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({'lastName': name});
        });
      });
      getFirstName();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getFirstName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours().primary,
        title: Text(
          'Profile',
          style: GoogleFonts.ubuntu(
            fontSize: 25,
            color: Colours().unSelectedText,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colours().primary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              //profile image
              const Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(''),
                ),
              ),
              const SizedBox(height: 40),
              //first name
              Text(
                'First Name',
                style: GoogleFonts.ubuntu(
                  fontSize: 28,
                  color: Colours().unSelectedText,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colours().borderColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      firstName,
                      style: GoogleFonts.ubuntu(
                        fontSize: 24,
                        color: Colours().unSelectedText,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        editMessageBox('First Name');
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colours().settingIconColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              //last name
              Text(
                'Last Name',
                style: GoogleFonts.ubuntu(
                  fontSize: 28,
                  color: Colours().unSelectedText,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colours().borderColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      lastName,
                      style: GoogleFonts.ubuntu(
                        fontSize: 24,
                        color: Colours().unSelectedText,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        editMessageBox('Last Name');
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colours().settingIconColor,
                        size: 30,
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
