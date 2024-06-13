import 'package:flutter/material.dart';
import 'package:labtracking/components/about_window.dart';
import 'package:labtracking/utils/routes.dart';

import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LabTrackingBar extends StatelessWidget implements PreferredSizeWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  LabTrackingBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Column(
        children: [
          Image.asset(
            'assets/images/white_icon.png',
            fit: BoxFit.cover,
            height: 30,
          ),
          const Text(
            "LabTracking",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 126, 217, 87),
      actions: [
        PopupMenuButton(
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
          itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 126, 217, 87),
                    ),
                    Text(" My Account"),
                  ],
                ),
              ),
              // const PopupMenuItem<int>(
              //   value: 1,
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.settings,
              //         color: Color.fromARGB(255, 126, 217, 87),
              //       ),
              //       Text(" Settings"),
              //     ],
              //   ),
              // ),
              // const PopupMenuItem(
              //   value: 2,
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.add,
              //         color: Color.fromARGB(255, 126, 217, 87),
              //       ),
              //       Text('Add new sample'),
              //     ],
              //   ),
              // ),
              // const PopupMenuItem(
              //   value: 3,
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.settings_suggest,
              //         color: Color.fromARGB(255, 126, 217, 87),
              //       ),
              //       Text(' Suggest new sample type'),
              //     ],
              //   ),
              // ),
              const PopupMenuItem<int>(
                value: 4,
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color.fromARGB(255, 126, 217, 87),
                      size: 23,
                    ),
                    Text(" About"),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 5,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Color.fromARGB(255, 126, 217, 87),
                      size: 23,
                    ),
                    Text(" Logout"),
                  ],
                ),
              ),
            ];
          },
          onSelected: (value) async {
            if (value == 0) {
              print("My account menu is selected.");
              // } else if (value == 1) {
              //   print("Settings menu is selected.");
              // } else if (value == 2) {
              //   print("New Sample menu is selected.");
              //   Navigator.of(context).pushNamed(AppRoutes.NEW_SAMPLE);
              // } else if (value == 3) {
              //   Navigator.of(context).pushNamed(AppRoutes.NEW_SAMPLE_TYPE);
            } else if (value == 4) {
              AboutWindow.aboutDialog(context);
              print("About is selected");
            } else if (value == 5) {
              await Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false);
              await AuthService.logout(_auth, _googleSignIn);
            }
          },
        ),
      ],
    );
  }
}
