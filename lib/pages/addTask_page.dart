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
      appBar: AppBar(
        backgroundColor: Colours().primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add Task',
          style: GoogleFonts.ubuntu(
            fontSize: 30,
            //fontWeight: FontWeight.bold,
            color: Colours().unSelectedText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //FormField(builder: builder),
          ],
        ),
      ),
    );
  }
}
