import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/about_window.dart';
import 'package:labtracking/components/sample_item.dart';
import 'package:labtracking/components/samples_list.dart';
import 'package:labtracking/screens/login_screen.dart';
import 'package:labtracking/screens/new_sample_screen.dart';
import 'package:labtracking/screens/new_sample_type_screen.dart';
import 'package:labtracking/utils/location_utill.dart';
import 'package:labtracking/utils/routes.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_service.dart';

class SampleDetailsScreen extends StatefulWidget {
  //final String labId;
  //const SampleDetailsScreen({required this.labId, super.key});

  @override
  State<SampleDetailsScreen> createState() => _SampleDetailsScreenState();
}

class _SampleDetailsScreenState extends State<SampleDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final sampleDetails = (ModalRoute.of(context)?.settings.arguments as Map);

    final String imageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: sampleDetails["latitude"],
      longitude: sampleDetails["longitude"],
    );

    final List<Widget> details = [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
            ),
          ),
        ),
      ),
    ];

    sampleDetails.forEach((key, value) {
      if (value != "") {
        details.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(key),
              Text(": "),
              Text(value.toString()),
            ],
          ),
        );
      }
    });
    print("OK $details");

    return Scaffold(
      appBar: AppBar(
        // /automaticallyImplyLeading: false,
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
                const PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text(" Settings"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text('Add new sample'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_suggest,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text(' Suggest new sample type'),
                    ],
                  ),
                ),
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
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                print("New Sample menu is selected.");
                Navigator.of(context).pushNamed(AppRoutes.NEW_SAMPLE);
              } else if (value == 3) {
                Navigator.of(context).pushNamed(AppRoutes.NEW_SAMPLE_TYPE);
              } else if (value == 4) {
                AboutWindow.aboutDialog(context);
                print("About is selected");
              } else if (value == 5) {
                await AuthService.logout(_auth, _googleSignIn);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false);

                print('deslogado');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: details,
        ),
      ),
    );
  }
}