import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/models/researcher.dart';
import 'dart:async';
import 'dart:convert';

class NewSampleService {
  Stream<List<Map<String, dynamic>>> samplesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('samples')
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
                return doc.data();
              },
            ).toList();
            controller.add(lista);
            print(lista);
          },
        );
      },
    );
  }

  static Future<void> saveGas(
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
      String gasType,
      String chamberType,
      String co2,
      String ch4,
      String no2,
      double? latitude,
      double? longitude) async {
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
        'gasType': gasType,
        'chamberType': chamberType,
        'co2': co2,
        'ch4': ch4,
        'no2': no2,
        'latitude': latitude,
        'longitude': longitude
      },
    );
  }

  static Future<void> saveSediment(
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
      String remineralization,
      String co2,
      String ch4,
      String no2,
      String sand,
      String silt,
      String clay,
      String n,
      String delta13c,
      String delta15n,
      String density,
      double? latitude,
      double? longitude) async {
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
        'remineralization': remineralization,
        'co2': co2,
        'ch4': ch4,
        'no2': no2,
        'sand': sand,
        'silt': silt,
        'clay': clay,
        'n': n,
        'delta13c': delta13c,
        'delta15n': delta15n,
        'density': density,
        'latitude': latitude,
        'longitude': longitude
      },
    );
  }

  static Future<void> saveWater(
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
      String waterType,
      String co2,
      String ch4,
      String no2,
      double? latitude,
      double? longitude) async {
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
        'waterType': waterType,
        'co2': co2,
        'ch4': ch4,
        'no2': no2,
        'latitude': latitude,
        'longitude': longitude
      },
    );
  }

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
      double? latitude,
      double? longitude) async {
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
        'latitude': latitude,
        'longitude': longitude
      },
    );
  }
}
