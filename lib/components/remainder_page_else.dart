import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class DirectToAddTaskPage extends StatefulWidget {
  final void Function()? onTap;

  const DirectToAddTaskPage({
    super.key,
    required this.onTap,
  });

  @override
  State<DirectToAddTaskPage> createState() => _DirectToAddTaskPageState();
}

class _DirectToAddTaskPageState extends State<DirectToAddTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Column(
          children: [
            Center(
              child: Text(
                'No tasks for this date',
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  //fontWeight: FontWeight.bold,
                  color: Colours().unSelectedText,
                ),
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: widget.onTap,
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colours().borderColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Add a task',
                    style: GoogleFonts.ubuntu(
                      fontSize: 22,
                      //fontWeight: FontWeight.bold,
                      color: Colours().unSelectedText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
