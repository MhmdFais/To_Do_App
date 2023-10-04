import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/components/text_field.dart';
import 'package:to_do/pages/otp_page.dart';

class ForgotPasswordPhone extends StatefulWidget {
  const ForgotPasswordPhone({super.key});

  @override
  State<ForgotPasswordPhone> createState() => _ForgotPasswordPhoneState();
}

class _ForgotPasswordPhoneState extends State<ForgotPasswordPhone> {
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
                  Icons.mobile_friendly_rounded,
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
                'Enter your phone number and we will send you a code to reset your password',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              //email
              TextField(
                keyboardType: TextInputType.phone,
                obscureText: false,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colours().borderColor,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: 'Phone Number',
                    hintStyle: GoogleFonts.ubuntu(
                      fontSize: 18,
                    )),
              ),
              //reset password button
              const SizedBox(height: 165),
              MainButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OTPScreen(),
                    ),
                  );
                },
                text: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
