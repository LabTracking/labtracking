import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/auth_service.dart';

class SamplesScreen extends StatefulWidget {
  const SamplesScreen({super.key});

  @override
  State<SamplesScreen> createState() => _SamplesScreenState();
}

class _SamplesScreenState extends State<SamplesScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
            Text("Samples Screen")
          ],
        ),
      ),
    );
  }
}
