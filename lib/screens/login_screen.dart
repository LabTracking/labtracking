import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/white_icon.png',
              fit: BoxFit.cover,
              height: 40,
            ),
            const Text(
              "LabTracking",
              style: TextStyle(
                color: Colors.white,
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
            SignInButton(
              Buttons.GoogleDark,
              onPressed: () async {
                setState(() {
                  AuthService.login(_auth, _googleSignIn);
                  isLoading = false;
                });
              },
              text: "Sign in with Google/Gmail",
            ),
          ],
        ),
      ),
    );
  }
}
