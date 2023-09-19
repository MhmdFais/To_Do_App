import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class SignInWith extends StatelessWidget {
  final String text;
  final String image;

  const SignInWith({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colours().borderColor,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              color: Colours().unSelectedText,
            ),
          ),
          const SizedBox(width: 10),
          Image.asset(
            image,
            width: 30,
            height: 30,
          ),
        ],
      ),
    );
  }
}
