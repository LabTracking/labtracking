import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:labtracking/models/researcher.dart';
import 'package:labtracking/screens/loading_screen.dart';
import 'package:labtracking/screens/new_researcher_screen.dart';
import 'package:labtracking/screens/samples_screen.dart';
import 'package:labtracking/services/auth_service.dart';

class SignUpOrAppScreen extends StatelessWidget {
  const SignUpOrAppScreen({super.key});

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final researcherExists = arguments['researcherExists'] as bool;
    final user = arguments['user'] as User;
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
                    ? NewResearcherScreen(user: user)
                    : SamplesScreen();
              }
            },
          );
        }
      },
    );
  }
}
