import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/components/selection_tile.dart';
import 'package:to_do/components/signin_with.dart';
import 'package:to_do/components/text_field.dart';
import 'package:to_do/pages/forgot_pass_phone.dart';
import 'package:to_do/pages/forgot_password.dart';

class SignInContent extends StatefulWidget {
  const SignInContent({super.key});

  @override
  State<SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<SignInContent> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in user
  void userSignIn() async {
    //circular progress indicator
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        wrongEmailOrPassword();
      }
    }

    //pop circular progress indicator
    Navigator.pop(context);
  }

  //wrong email or password dialog box
  void wrongEmailOrPassword() {
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
              'Please check your email and password and try again',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Let\'s Sign',
              style: GoogleFonts.ubuntu(
                fontSize: 35,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            Text(
              'you in',
              style: GoogleFonts.ubuntu(
                fontSize: 35,
                //fontWeight: FontWeight.bold,
                color: Colours().unSelectedText,
              ),
            ),
            const SizedBox(height: 30),
            //email
            MyTextField(
              controller: usernameController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 20),
            //password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            //forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  //popup for email or phone number
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colours().forgotPassword,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            //sign in with google and apple
            Column(
              children: [
                Center(
                  child: Text(
                    'Or sign in with',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colours().unSelectedText,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const SignInWith(
                  text: 'Sign in with Google',
                  image: 'lib/images/google.png',
                ),
              ],
            ),
            const SizedBox(height: 110),
            //sign in button
            MainButton(
              onTap: userSignIn,
              text: 'Sign In',
            ),
          ],
        ),
      ),
    );
  }
}
