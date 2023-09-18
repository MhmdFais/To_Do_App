import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Colours extends StatelessWidget {
  Colours({super.key});

  //final Color primary = const Color(0xFFE5E5E5);
  final Color primary = Colors.orangeAccent.shade100;
  final Color buttonFill = Colors.orangeAccent;
  final Color unSelectedText = Colors.black;
  final Color selectedText = Colors.black;
  final Color buttonShadow = Colors.black.withOpacity(0.5);
  final Color forgotPassword = Colors.tealAccent.shade700;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
