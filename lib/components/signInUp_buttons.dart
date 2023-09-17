import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const StyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        color: isSelected ? Colours().buttonFill : Colors.transparent,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make the button transparent
          elevation: 0, // Remove button shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.ubuntu(
            fontSize: 22,
            color:
                isSelected ? Colours().selectedText : Colours().unSelectedText,
          ),
        ),
      ),
    );
  }
}
