import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/components/text_field.dart';
import 'package:to_do/pages/email_verify.dart';

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
  late BuildContext dialogContext;

  void createUserWithEmailAndPassword() async {
    //check if the fields are empty
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      wrongInputlAlert('Please fill all the fields');
      return;
    }

    //check if the password and confirm password are same
    if (passwordController.text != confirmPasswordController.text) {
      wrongInputlAlert('Please check your password');
      return;
    }

    //if passwords are same then continue to verify page
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );

        //navigate to verify page
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerification(
              email: usernameController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
            ),
          ),
        );
      } else {
        wrongInputlAlert('Please check your password');
        return;
      }
    } catch (e) {
      wrongInputlAlert(e.toString());
    }
  }

  //other message dialog box
  void wrongInputlAlert(String text) {
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return AlertDialog(
          title: Text(
            'Wronng Credentials',
            style: GoogleFonts.ubuntu(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colours().unSelectedText,
            ),
          ),
          content: Text(
            text,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //const SizedBox(height: 10),
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
            const SizedBox(height: 15),
            //first name
            MyTextField(
              controller: firstNameController,
              hintText: 'First Name',
              obscureText: false,
            ),
            const SizedBox(height: 14),
            //last name
            MyTextField(
              controller: lastNameController,
              hintText: 'Last Name',
              obscureText: false,
            ),
            const SizedBox(height: 14),
            //email
            MyTextField(
              controller: usernameController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 14),
            //password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 14),
            //confirm password
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 25),
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
