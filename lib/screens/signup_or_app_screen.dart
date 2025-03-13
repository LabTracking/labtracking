import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/models/researcher.dart';
import 'package:labtracking/screens/labs_screen.dart';
import 'package:labtracking/services/auth_service.dart';
import 'package:labtracking/utils/routes.dart';

class SignUpOrAppScreen extends StatelessWidget {
  const SignUpOrAppScreen({super.key});

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  _showNotRegisteredDialog(BuildContext context) async {
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
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return StreamBuilder<User?>(
            stream: _auth.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (authSnapshot.data == null) {
                // User is logged out, navigate to LoginScreen
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
                });
                return Container();
              }
              // User is logged in, check researcher data
              return StreamBuilder<Researcher?>(
                stream: AuthService().researcherChanges,
                builder: (ctx, researcherSnapshot) {
                  if (researcherSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (researcherSnapshot.hasError) {
                    return Text('Error: ${researcherSnapshot.error}');
                  }
                  if (!researcherSnapshot.hasData) {
                    // Researcher does not exist, show dialog and logout
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await _showNotRegisteredDialog(context);
                      await AuthService.logout(_auth, _googleSignIn);
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.HOME);
                    });
                    return Container();
                  }
                  // Convert Researcher object to Map<String, dynamic>
                  final researcherData = researcherSnapshot.data!.toMap();
                  print('Researcher Data: $researcherData'); // Debug print
                  // Researcher exists, proceed to LabsScreen
                  return LabsScreen(
                    researcherData: researcherData,
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
