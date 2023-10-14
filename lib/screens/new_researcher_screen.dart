import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/auth_service.dart';

class NewResearcherScreen extends StatefulWidget {
  const NewResearcherScreen({super.key});

  @override
  State<NewResearcherScreen> createState() => _NewResearcherScreenState();
}

class _NewResearcherScreenState extends State<NewResearcherScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: double.infinity,
              height: 300,
            ),
            const Text("New Researcher Screen"),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                AuthService.signup(user);
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
