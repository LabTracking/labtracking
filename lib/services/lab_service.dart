import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/models/researcher.dart';
import 'dart:async';
import 'dart:convert';

class LabService {
  Stream<List<Map<String, dynamic>>> labsStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('labs')

        // .withConverter(
        //   fromFirestore: fromFirestore,
        //   toFirestore: toFirestore,
        // )
        // .orderBy('createdAt', descending: true)
        .snapshots();

    print(snapshots);

    return Stream<List<Map<String, dynamic>>>.multi(
      (controller) {
        snapshots.listen(
          (snapshot) {
            List<Map<String, dynamic>> lista = snapshot.docs.map(
              (doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              },
            ).toList();
            controller.add(lista);
            print(lista);
          },
        );
      },
    );
  }

  static Future<void> saveLab(
    String labName,
    String labLeader,
    String? createdBy,
    List<String>? members,
  ) async {
    final store = FirebaseFirestore.instance;

    // QuerySnapshot researcherDocRef = await FirebaseFirestore.instance
    //     .collection('researchers')
    //     .where('email', isEqualTo: user)
    //     .get();

    // final researcherDocs = researcherDocRef.docs;
    // final researcher = researcherDocs[0];
    // print(researcher);
    await store.collection('labs').add(
      {
        'labName': labName,
        'leaderName': labLeader,
        'createdBy': createdBy,
        'members': members,
      },
    );
  }
}
