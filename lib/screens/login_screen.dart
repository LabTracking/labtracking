import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/utils/routes.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
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
            isLoading == false
                ? SignInButton(
                    Buttons.GoogleDark,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await AuthService.login(_auth, _googleSignIn);
                      setState(() {
                        user = _auth.currentUser;
                      });
                      await Navigator.of(context)
                          .pushNamed(AppRoutes.SIGNUP_OR_APP, arguments: user);

                      setState(() {
                        isLoading = false;
                      });
                    },
                    text: "Sign in with Google/Gmail",
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Color.fromARGB(255, 92, 225, 230),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Loading",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 92, 225, 230),
                          ),
                        )
                      ],
                    ),
                  ),
            TextButton(
              onPressed: () {
                AuthService.logout(_auth, _googleSignIn);
              },
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            )
          ],
        ),
      ),
    );
  }
}
