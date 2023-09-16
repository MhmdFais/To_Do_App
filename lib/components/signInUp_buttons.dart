import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryButton extends StatelessWidget {
  final String text;

  const SecondaryButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.ubuntu(fontSize: 25, color: Colors.black),
        ),
      ),
    );
  }
}
