import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/about_window.dart';

import 'package:labtracking/components/lab_tracking_bar.dart';
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

  void _addLab(String labName, List<String> leaderNames, String? createdBy,
      [List<String> members = const []]) async {
    setState(() {
      isLoading = true;
    });

    // if (widget.email == null) {
    //   return;
    // }
    await LabService.saveLab(labName, leaderNames, createdBy, members);

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
      appBar: LabTrackingBar(),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: double.infinity,
              height: 150,
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
