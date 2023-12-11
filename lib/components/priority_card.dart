import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class QueueCard extends StatelessWidget {
  final String? firtSentence;
  final String? secondSentence;

  const QueueCard({
    Key? key,
    required this.firtSentence,
    required this.secondSentence,
  }) : super(key: key);

  //colours according to priority
  Color priorityColor(String firstSentence) {
    if (firtSentence == 'High') {
      return const Color.fromARGB(255, 225, 98, 88);
    } else if (firtSentence == 'Medium') {
      return const Color.fromARGB(255, 237, 224, 104);
    } else {
      return const Color.fromARGB(255, 124, 214, 127);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          height: MediaQuery.of(context).size.height * 0.22,
          width: MediaQuery.of(context).size.width * 0.46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: priorityColor(firtSentence!),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firtSentence!,
                  style: GoogleFonts.ubuntu(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colours().unSelectedText,
                  ),
                ),
                Text(
                  secondSentence!,
                  style: GoogleFonts.ubuntu(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colours().unSelectedText,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 17,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colours().buttonFill,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
