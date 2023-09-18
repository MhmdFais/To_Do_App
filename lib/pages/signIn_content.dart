import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/text_field.dart';

class SignInContent extends StatefulWidget {
  const SignInContent({super.key});

  @override
  State<SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<SignInContent> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
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
          const SizedBox(height: 50),
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
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    color: Colours().unSelectedText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          //sign in with google
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
              const SizedBox(width: 10),
              Image.asset(
                'assets/images/google.png',
                width: 5,
                height: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
