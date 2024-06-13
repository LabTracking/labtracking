import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/about_window.dart';
import 'package:labtracking/components/new_sample_type_form.dart';
import 'package:labtracking/services/new_sample_type_service.dart';

import '../services/auth_service.dart';
import '../utils/routes.dart';
import '../components/lab_tracking_bar.dart';

class NewSampleTypeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  NewSampleTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LabTrackingBar(),
      body: Center(
        child: NewSampleTypeForm(email: _auth.currentUser!.email),
      ),
    );
  }
}
