import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/components/text_field.dart';

class SignUpContent extends StatefulWidget {
  const SignUpContent({super.key});

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
          const SizedBox(height: 20),
          //confirm password
          MyTextField(
            controller: confirmPasswordController,
            hintText: 'Confirm Password',
            obscureText: true,
          ),
          const SizedBox(height: 177),
          //sign up button
          MainButton(
            onTap: () {},
            text: 'Next',
          ),
        ],
      ),
    );
  }
}
