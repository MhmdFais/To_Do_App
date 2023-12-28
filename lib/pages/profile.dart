import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/components/setting_components.dart';
import 'package:to_do/components/utils.dart';
import 'package:to_do/pages/auth_page.dart';
import 'package:to_do/settings/change_password.dart';
import 'package:to_do/settings/delete_account.dart';
import 'package:to_do/settings/profie_settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? img;

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      img = image;
    });
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserAuth(),
        ),
      );
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

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
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: img != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.memory(
                                    img!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    size: 220,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 40,
                        child: Container(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            onPressed: selectImage,
                            icon: Icon(
                              Icons.add_a_photo_outlined,
                              size: 40,
                              color: Colours().unSelectedText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileDetails()),
                        );
                      },
                    ),
                    SettingsMenu(
                      title: 'Password',
                      icon: Icons.lock_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePassword(),
                          ),
                        );
                      },
                    ),
                    // SettingsMenu(
                    //   title: 'Language',
                    //   icon: Icons.language_outlined,
                    //   onTap: () {},
                    // ),
                    SettingsMenu(
                      title: 'Delete Account',
                      icon: Icons.heart_broken,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeleteAccount(),
                          ),
                        );
                      },
                    ),
                    SettingsMenu(
                      title: 'Sign Out',
                      icon: Icons.logout,
                      onTap: signOut,
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
