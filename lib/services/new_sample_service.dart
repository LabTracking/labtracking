import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/models/researcher.dart';

class NewSampleService {
  static Future<void> save(
    String sampleType,
    String researcherId,
    String researchEmail,
    String date,
    String entryDate,
    String exitDate,
    String location,
    String history,
    String observation,
    String ecosystem,
  ) async {
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
        'researcherId': researcherId,
        'researcherEmail': researchEmail,
        'sampleType': sampleType,
        'date': date,
        'entryDate': entryDate,
        'exitDate': exitDate,
        'location': location,
        'history': history,
        'observation': observation,
        'ecosystem': ecosystem,
      },
    );
  }
}
