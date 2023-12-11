import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: Text(
                'Add a new task!',
                style: GoogleFonts.ubuntu(
                  fontSize: 25,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
