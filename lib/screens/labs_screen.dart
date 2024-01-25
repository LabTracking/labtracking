import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/about_window.dart';
import 'package:labtracking/components/labs_list.dart';
import 'package:labtracking/components/new_lab_form.dart';

import 'package:labtracking/screens/login_screen.dart';
import 'package:labtracking/screens/new_sample_type_screen.dart';
import 'package:labtracking/services/lab_service.dart';
import 'package:labtracking/utils/routes.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_service.dart';

class LabsScreen extends StatefulWidget {
  const LabsScreen({super.key});

  @override
  State<LabsScreen> createState() => _LabsScreenState();
}

class _LabsScreenState extends State<LabsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  void _addLab(String labName, String leaderName, String? createdBy,
      [List<String> members = const []]) async {
    setState(() {
      isLoading = true;
    });

    // if (widget.email == null) {
    //   return;
    // }
    await LabService.saveLab(labName, leaderName, createdBy, members);

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laboratory added'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  _openNewSubjectFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: NewLabForm(_addLab, _auth.currentUser?.email),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: double.infinity,
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business,
                  color: Color.fromARGB(255, 126, 217, 87),
                ),
                Text(
                  "Laboratories",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
            LabsList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {
          _openNewSubjectFormModal(context);
        },
        backgroundColor: const Color.fromARGB(255, 126, 217, 87),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
