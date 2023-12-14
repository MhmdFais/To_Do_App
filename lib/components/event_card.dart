import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';

class EventCard extends StatefulWidget {
  final String taskName;
  final String taskPriority;

  const EventCard({
    super.key,
    required this.taskName,
    required this.taskPriority,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  void clicked() {
    print('clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colours().primary,
          boxShadow: [
            BoxShadow(
              color: Colours().buttonShadow,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              //priority color
              Container(
                height: 50,
                width: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: widget.taskPriority == 'High'
                      ? Colours().highPriority
                      : widget.taskPriority == 'Medium'
                          ? Colours().mediumPriority
                          : Colours().lowPriority,
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskName,
                      style: GoogleFonts.ubuntu(
                        fontSize: 22,
                        //fontWeight: FontWeight.bold,
                        color: Colours().unSelectedText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    //priority
                    Text(
                      '${widget.taskPriority} Priority',
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        //fontWeight: FontWeight.bold,
                        color: Colours().unSelectedText,
                      ),
                    ),
                  ],
                ),
              ),
              //icons for edit and delete
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    //edit icon
                    GestureDetector(
                      onTap: clicked,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 15),
                    //delete icon
                    GestureDetector(
                      onTap: clicked,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
