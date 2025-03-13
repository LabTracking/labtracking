import 'package:flutter/material.dart';
import 'package:labtracking/components/lab_item.dart';

import 'package:labtracking/services/lab_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LabsList extends StatelessWidget {
  final Map<String, dynamic> researcherData;
  const LabsList({required this.researcherData, super.key});

  @override
  Widget build(BuildContext context) {
    //final currentUser = AuthService().currentUser;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    return Expanded(
      child: StreamBuilder<List>(
        stream: LabService.labsStream(_auth.currentUser!.email.toString()),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work,
                  color: Colors.lightBlue,
                ),
                Text(
                  'Add a new lab',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ));
          } else {
            List labs = snapshot.data!.toList();
            print("AQUI Ó" + labs.toString());
            return ListView.builder(
              //reverse: true,
              itemCount: labs.length,
              itemBuilder: (ctx, i) => LabItem(
                id: labs[i]['id']!,
                labName: labs[i]['labName'],
                leaderName: labs[i]['createdBy'],
                members: labs[i]['members'] ?? [],
                researcherData: researcherData,
              ),
            );
          }
        },
      ),
    );
  }
}
