import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/components/text_field.dart';
import 'package:to_do/pages/otp_page.dart';
import 'package:to_do/pages/signIn_content.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final usernameController = TextEditingController();

  //reset password
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: usernameController.text,
      );
      emailSent();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        wrongEmail();
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        wrongEmail();
        print('Wrong password provided for that user.');
      }
    }
  }

  //wrong email or password dialog box
  void wrongEmail() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Wrong email or password',
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            content: Text(
              'Please check your email and try again',
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
          );
        });
  }

  //email send dialog box
  void emailSent() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Email sent',
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            content: Text(
              'Please check your email and follow the instructions to reset your password',
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      appBar: AppBar(
        backgroundColor: Colours().primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          //splashRadius: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Icon(
                  Icons.mail_outline_rounded,
                  size: 110,
                  color: Colours().buttonFill,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Forgot Password',
                style: GoogleFonts.ubuntu(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Enter your email address associated with your account and we\'ll send you a link to reset your password',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              //email
              MyTextField(
                controller: usernameController,
                hintText: 'Email',
                obscureText: false,
              ),
              //reset password button
              const SizedBox(height: 145),
              MainButton(
                onTap: passwordReset,
                text: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
