import 'package:flutter/material.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/signInUp_buttons.dart';
import 'package:to_do/pages/signIn_content.dart';
import 'package:to_do/pages/signUp_content.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _currentPage = 0;

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  StyledButton(
                    text: "Sign In",
                    onPressed: () {
                      _changePage(0); // Set the current page to 0 (Sign In)
                    },
                    isSelected: _currentPage == 0,
                  ),
                  const SizedBox(width: 10),
                  StyledButton(
                    text: "Sign Up",
                    onPressed: () {
                      _changePage(1); // Set the current page to 1 (Sign Up)
                    },
                    isSelected: _currentPage == 1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Content based on the selected page
            if (_currentPage == 0) ...[
              const SignInContent(),
            ] else if (_currentPage == 1) ...[
              const SignUpContent(),
            ],
          ],
        ),
      ),
    );
  }
}
