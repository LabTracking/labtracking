import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/components/labs_list.dart';
import 'package:labtracking/components/new_lab_form.dart';
import 'package:labtracking/screens/new_user_form_screen.dart';
import 'package:labtracking/services/lab_service.dart';

class LabsScreen extends StatefulWidget {
  Map<String, dynamic> researcherData;

  LabsScreen({required this.researcherData, super.key});

  @override
  State<LabsScreen> createState() => _LabsScreenState();
}

class _LabsScreenState extends State<LabsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  void _addLab(String labName, List<String> leaderNames, String? createdBy,
      [List<String> members = const []]) async {
    // setState(() {
    //   isLoading = true;
    // });

    await LabService.saveLab(labName, leaderNames, createdBy, members);

    // if (mounted) {
    //   Navigator.of(context).pop();
    //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Laboratory added'),
    //       duration: Duration(seconds: 2),
    //     ),
    //   );
    // }

    // setState(() {
    //   isLoading = false;
    // });
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
            // Safely pass email, with fallback in case it's null
            child: NewLabForm(_addLab, _auth.currentUser?.email ?? ''),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.researcherData.toString() +
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    return Scaffold(
      appBar: LabTrackingBar(
        researcherData: widget.researcherData,
        showPopup: false,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: double.infinity,
              height: 150,
            ),
            const Row(
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
            //isLoading
            //    ? const CircularProgressIndicator() // Show loading indicator
            LabsList(
                researcherData:
                    widget.researcherData), // Show list if not loading
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.researcherData["type"] == "admin")
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                if (widget.researcherData['type'] == 'admin') {
                  //_openNewSubjectFormModal(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewUserFormScreen(),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Access denied"),
                        content:
                            Text("You are not allowed to perform this action"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.person_add),
            ),
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              if (widget.researcherData['type'] != 'observer') {
                _openNewSubjectFormModal(context);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Access denied"),
                      content:
                          Text("You are not allowed to perform this action"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            backgroundColor: const Color.fromARGB(255, 126, 217, 87),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //drawer: widget.researcherData["type"] == "admin" ? MainDrawer() : null,
    );
  }
}
