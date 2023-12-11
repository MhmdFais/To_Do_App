import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/components/signin_with.dart';
import 'package:to_do/components/text_field.dart';
import 'package:to_do/pages/bottom_navigation.dart';
import 'package:to_do/pages/forgot_password.dart';
import 'package:to_do/pages/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInContent extends StatefulWidget {
  const SignInContent({super.key});

  @override
  State<SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<SignInContent> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in user
  // void userSignIn() async {
  //   //circular progress indicator
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );

  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: usernameController.text,
  //       password: passwordController.text,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found' || e.code == 'wrong-password') {
  //       //wrongEmailOrPassword();
  //     }
  //   }

  //   //pop circular progress indicator
  //   Navigator.pop(context);
  // }

  void userSignIn() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      wrongInputlAlert('Please fill all the fields');
      return;
    }

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );

    try {
      // Sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      // Sign-in successful
      if (mounted) {
        //setvalidity();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigation(),
          ),
        );
      }
    } on FirebaseAuthException catch (ex) {
      // Handle sign-in errors
      if (ex.code == 'user-not-found' || ex.code == 'wrong-password') {
        wrongInputlAlert('Invalid username or password');
      } else {
        wrongInputlAlert('Invalid username or password');
      }
    }
  }

  //wrong email or password dialog box
  void wrongInputlAlert(String error) {
    showDialog(
      context: context,
      builder: (context) {
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
            'Please check your Email and Password and try again',
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

  //sign in with google
  Future<UserCredential> signInWithGoogle() async {
    // try {
    //   GoogleAuthProvider googleProvider = GoogleAuthProvider();
    //   _auth.signInWithPopup(googleProvider);
    // } catch (e) {
    //   print(e);
    // }

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {});
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
            GestureDetector(
              onTap: signInWithGoogle,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Or sign up with',
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        color: Colours().unSelectedText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const SignInWith(
                    text: 'Google',
                    image: 'lib/images/google.png',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 85),
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
