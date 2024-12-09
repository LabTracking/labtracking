import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:labtracking/models/researcher.dart';
import 'package:labtracking/screens/labs_screen.dart';

//import 'package:labtracking/screens/new_researcher_screen.dart';

import 'package:labtracking/services/auth_service.dart';

class SignUpOrAppScreen extends StatelessWidget {
  const SignUpOrAppScreen({super.key});

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  _showNotRegisteredDialog(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("User not registered"),
            content: const Text(
                "It seems that this user is not registered. Please contact support."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final researcherExists = arguments['researcherExists'] as bool;
    final user = arguments['user'] as User;

    final Map<String, dynamic>? researcherData =
        arguments['researcherData'] as Map<String, dynamic>;

    if (researcherData != null) {
      print('Name: ${researcherData['name']}');
      print('Email: ${researcherData['email']}');
    } else {
      print('Researcher data is null.');
    }

    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 126, 217, 87),
            ),
          );
        } else {
          return StreamBuilder<Researcher?>(
            stream: AuthService().researcherChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 126, 217, 87),
                  ),
                );
              } else {
                return snapshot.hasData && !researcherExists
                    ? _showNotRegisteredDialog(context)
                    : LabsScreen(
                        researcherData: researcherData!,
                      );
              }
            },
          );
        }
      },
    );
  }
}
