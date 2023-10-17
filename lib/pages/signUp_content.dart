import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/pages/home_page.dart';

class SignUpContent extends StatefulWidget {
  const SignUpContent({super.key});

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  void createUserWithEmailAndPassword() async {
    //check if the fields are empty
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      wrongEmailOrPassword('Please fill all the fields');
      return;
    }

    //check if the password and confirm password are same
    if (passwordController.text != confirmPasswordController.text) {
      wrongEmailOrPassword('Password and Confirm Password are not same');
      return;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      //check if the email verification is send or not
      if (credential.user != null) {
        //send email verification
        await credential.user?.sendEmailVerification();

        //add user to firestore
        addUserToFirestore();

        //show dialog box
        Message('Verification email has been sent to your email address.');

        //navigate to home page
        navigateToHomeIfEmailVerified();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        wrongEmailOrPassword('Weak password');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        wrongEmailOrPassword('Email already in use');
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  //navigate to home page if email is verified
  void navigateToHomeIfEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      navigateToHome();
    }
  }

  //add user details to firestore
  void addUserToFirestore() async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': usernameController.text,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
    });
  }

  //wrong email or password dialog box
  void wrongEmailOrPassword(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              text,
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            content: Text(
              'Please try again',
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
          );
        });
  }

  //other message dialog box
  void Message(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              text,
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
          );
        });
  }

  //navigate to home page
  void navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const Home();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Create your own',
              style: GoogleFonts.ubuntu(
                fontSize: 35,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            Text(
              'account',
              style: GoogleFonts.ubuntu(
                fontSize: 35,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            const SizedBox(height: 30),
            //first name
            MyTextField(
              controller: firstNameController,
              hintText: 'First Name',
              obscureText: false,
            ),
            const SizedBox(height: 17),
            //last name
            MyTextField(
              controller: lastNameController,
              hintText: 'Last Name',
              obscureText: false,
            ),
            const SizedBox(height: 17),
            //email
            MyTextField(
              controller: usernameController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 17),
            //password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 17),
            //confirm password
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 27),
            //sign up button
            MainButton(
              onTap: createUserWithEmailAndPassword,
              text: 'Let\'s Create!',
            ),
          ],
        ),
      ),
    );
  }
}
