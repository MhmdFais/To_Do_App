import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class SelectionTiles extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Icon icons_selected;

  const SelectionTiles({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icons_selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          //color: Colours().primary,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colours().borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icons_selected.icon, size: 40),
            const SizedBox(width: 15),
            Text(
              text,
              style: GoogleFonts.ubuntu(
                fontSize: 30,
                color: Colours().unSelectedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
