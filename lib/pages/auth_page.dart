import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/pages/bottom_navigation.dart';
import 'package:to_do/pages/login_toggle_page.dart';

class UserAuth extends StatelessWidget {
  const UserAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const BottomNavigation();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
