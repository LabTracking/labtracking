import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:labtracking/models/researcher.dart';

class NewSampleTypeService {
  static void save(String sampleType, Researcher researcher) async {
    final store = FirebaseFirestore.instance;
    final docRef = await store.collection('sampleTypes').add(
      {
        'sampleType': sampleType,
        'researcherId': researcher.id,
      },
    );
  }
}
