import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/pages/forgot_password.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void changePassword() async {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      errorMessage('Please fill all the fields');
      return;
    }

    if (newPassword == confirmPassword) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        AuthCredential credential = EmailAuthProvider.credential(
            email: user!.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        successMessage('Password updated successfully');
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        errorMessage('Please check your password');
      }
    } else {
      errorMessage('Please check your password');
    }
  }

  //error message
  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Wrong Input',
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

  //Success message
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
          'Change Password',
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
              //old password
              Text(
                'Current password',
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  color: Colours().unSelectedText,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your current password',
                  hintStyle: GoogleFonts.ubuntu(
                    fontSize: 20,
                    color: Colours().settingTextColour,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
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
                    fontSize: 20,
                    color: Colours().forgotPassword,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              //new password
              Text(
                'New password',
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  color: Colours().unSelectedText,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your new password',
                  hintStyle: GoogleFonts.ubuntu(
                    fontSize: 20,
                    color: Colours().settingTextColour,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              //confirm password
              Text(
                'Confirm password',
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  color: Colours().unSelectedText,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm your new password',
                  hintStyle: GoogleFonts.ubuntu(
                    fontSize: 20,
                    color: Colours().settingTextColour,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colours().borderColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.13),
              //change password button
              MainButton(
                onTap: changePassword,
                text: 'Update Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
