import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/models/researcher.dart';

class NewSampleService {
  static Future<void> save(String sampleType, String name) async {
    //, String user) async {
    final store = FirebaseFirestore.instance;

    // QuerySnapshot researcherDocRef = await FirebaseFirestore.instance
    //     .collection('researchers')
    //     .where('email', isEqualTo: user)
    //     .get();

    // final researcherDocs = researcherDocRef.docs;
    // final researcher = researcherDocs[0];
    // print(researcher);
    await store.collection('samples').add(
      {
        'sampleType': sampleType,
        'name': name,
        //'researcherId': researcher['id'],
        //'researcherEmail': user
      },
    );
  }
}
