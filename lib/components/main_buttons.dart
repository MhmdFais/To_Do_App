import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/colors.dart';

class MainButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const MainButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 400,
        decoration: BoxDecoration(
          color: Colours().buttonFill,
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colours().buttonShadow,
              offset: const Offset(2, 4),
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.ubuntu(
                fontSize: 25,
                //fontWeight: FontWeight.bold,
                color: Colours().selectedText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
