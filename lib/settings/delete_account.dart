import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/pages/forgot_password.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final passwordController = TextEditingController();

  void deleteAccount() async {
    String password = passwordController.text;
    if (password.isEmpty) {
      errorMessage('Please enter password');
      return;
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credential =
          EmailAuthProvider.credential(email: user!.email!, password: password);
      await user.reauthenticateWithCredential(credential);
      await user.delete();
      successMessage('Account deleted successfully');
      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
      errorMessage('Please check your password');
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Success',
            style: GoogleFonts.ubuntu(
              fontSize: 25,
              color: Colours().unSelectedText,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              color: Colours().unSelectedText,
            ),
          ),
        );
      },
    );
  }

  void successMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Success',
            style: GoogleFonts.ubuntu(
              fontSize: 25,
              color: Colours().unSelectedText,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              color: Colours().unSelectedText,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      appBar: AppBar(
        title: Text(
          'Delete Account',
          style: GoogleFonts.ubuntu(
            fontSize: 25,
            color: Colours().unSelectedText,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colours().primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'This will delete Account',
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  color: Colours().unSelectedText,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'This will delete all your data and you will not be able to recover it.',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  color: Colours().unSelectedText,
                  //fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: passwordController,
                cursorColor: Colours().unSelectedText,
                obscureText: true,
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  color: Colours().unSelectedText,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  hintStyle: GoogleFonts.ubuntu(
                    fontSize: 20,
                    color: Colours().unSelectedText,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colours().unSelectedText,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colours().unSelectedText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPassword(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      color: Colours().forgotPassword,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.45),
              MainButton(
                onTap: () {},
                text: 'Delete Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
