import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/models/new_researcher_form_data.dart';
import 'package:labtracking/utils/routes.dart';
import 'package:provider/provider.dart';

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
    final newResearcherFormData =
        Provider.of<NewResearcherFormData>(context, listen: false);
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
                ? Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 126, 217, 87),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await AuthService.login(_auth, _googleSignIn);
                        newResearcherFormData.updateName(
                            _googleSignIn.currentUser?.displayName ?? '');
                        newResearcherFormData.updateEmail(
                            _googleSignIn.currentUser?.email ?? '');
                        setState(() {
                          user = _auth.currentUser;
                        });

                        final researcherExists =
                            await AuthService.researcherExists(user);
                        await Navigator.of(context)
                            .pushNamed(AppRoutes.SIGNUP_OR_APP, arguments: {
                          'user': user,
                          'researcherExists': researcherExists,
                          'auth': _auth,
                          'google': _googleSignIn,
                        });

                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/images/google_logo.png',
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Sign in with Gmail",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
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
            // TextButton(
            //   onPressed: () {
            //     AuthService.logout(_auth, _googleSignIn);
            //   },
            //   child: const Text(
            //     "Logout",
            //     style: TextStyle(fontSize: 18, color: Colors.green),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
