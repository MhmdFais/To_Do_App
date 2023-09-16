import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/main_buttons.dart';
import 'package:to_do/pages/login_page.dart';
import '../components/colors.dart';

class Startup extends StatefulWidget {
  const Startup({super.key});

  @override
  State<Startup> createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 300),
            Center(
              child: Text('Startup Page',
                  style: GoogleFonts.ubuntu(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(height: 280),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Login();
                }));
              },
              child: Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      'Start',
                      style: GoogleFonts.ubuntu(
                        fontSize: 25,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}