import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/main_buttons.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

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
              //text
              Center(
                child: Text(
                  'Enter Code',
                  style: GoogleFonts.ubuntu(
                    fontSize: 50,
                    //fontWeight: FontWeight.bold,
                    color: Colours().unSelectedText,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter the 6-digit code sent to your phone number',
                style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
              const SizedBox(height: 50),
              //otp
              OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.blueGrey.shade100,
                filled: true,
                //borderColor: Colours().buttonFill,
                enabledBorderColor: Colors.blueGrey.shade100,
                focusedBorderColor: Colours().buttonFill,
                textStyle: GoogleFonts.ubuntu(
                  fontSize: 25,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
                borderRadius: BorderRadius.circular(10),
                fieldWidth: 50.0,
                onSubmit: (code) {
                  print(code);
                },
              ),
              const SizedBox(height: 315),
              //verify button
              MainButton(
                onTap: () {},
                text: 'Verify',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
