import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/pages/home_page.dart';
import 'package:to_do/pages/login_toggle_page.dart';

class EmailVerification extends StatefulWidget {
  late String email;
  late String firstName;
  late String lastName;

  EmailVerification(
      {required this.email,
      required this.firstName,
      required this.lastName,
      super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  void Function()? onTap;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  bool _mounted = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    isEmailVerified = user?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) {
          if (_mounted) {
            // Check if the widget is still mounted
            checkIsEmailVerified();
          } else {
            timer?.cancel();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _mounted = false;
    super.dispose();
  }

  Future<void> checkIsEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });

      if (isEmailVerified) {
        try {
          //check if the user already exists
          final QuerySnapshot result = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: widget.email)
              .limit(1)
              .get();

          if (result.docs.isEmpty) {
            //create the user
            await FirebaseFirestore.instance.collection('users').add({
              'email': widget.email,
              'firstName': widget.firstName,
              'lastName': widget.lastName,
            });
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });

      await Future.delayed(const Duration(seconds: 5));

      setState(() {
        canResendEmail = true;
      });
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return const Home();
    } else {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 100,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 20),
                //message
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text("Verify your email address",
                          style: GoogleFonts.ubuntu(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      const SizedBox(height: 15),
                      Text(
                        "We have just send email verification link to your email. Please check email and click on that link",
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "If you haven't recieved the link yet, please click on Resend button",
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                //Resend button
                MainButton(
                  onTap: canResendEmail ? sendVerificationEmail : null,
                  text: canResendEmail ? "Resend" : "Please wait...",
                ),
                const SizedBox(height: 20),
                //cancel button
                GestureDetector(
                  onTap: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      FirebaseAuth.instance.signOut();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
}
