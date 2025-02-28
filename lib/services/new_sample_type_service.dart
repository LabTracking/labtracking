import 'package:cloud_firestore/cloud_firestore.dart';

class NewSampleTypeService {
  static Future<void> save(String sampleType, String user) async {
    final store = FirebaseFirestore.instance;

    QuerySnapshot researcherDocRef = await FirebaseFirestore.instance
        .collection('researchers')
        .where('email', isEqualTo: user)
        .get();

    final researcherDocs = researcherDocRef.docs;
    final researcher = researcherDocs[0];
    print(researcher);
    await store.collection('sampleTypes').add(
      {
        'sampleType': sampleType,
        'researcherId': researcher['id'],
        'researcherEmail': user
      },
    );
  }
}
