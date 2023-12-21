import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/setting_components.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours().primary,
      appBar: AppBar(
        backgroundColor: Colours().primary,
        title: Text(
          'Setttigs',
          style: GoogleFonts.ubuntu(
            fontSize: 25,
            color: Colours().unSelectedText,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  height: 250,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SettingsMenu(
                      title: 'Profile',
                      icon: Icons.account_circle_outlined,
                      onTap: () {},
                    ),
                    SettingsMenu(
                      title: 'Email',
                      icon: Icons.email_outlined,
                      onTap: () {},
                    ),
                    SettingsMenu(
                      title: 'Password',
                      icon: Icons.lock_outline,
                      onTap: () {},
                    ),
                    SettingsMenu(
                      title: 'Language',
                      icon: Icons.language_outlined,
                      onTap: () {},
                    ),
                    SettingsMenu(
                      title: 'Delete Account',
                      icon: Icons.heart_broken,
                      onTap: () {},
                    ),
                    SettingsMenu(
                      title: 'Sign Out',
                      icon: Icons.logout,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
