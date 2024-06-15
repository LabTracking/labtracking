import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/models/researcher.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

class NewSampleService {
  Stream<List<Map<String, dynamic>>> samplesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('samples')
        // .withConverter(
        //   fromFirestore: fromFirestore,
        //   toFirestore: toFirestore,
        // )
        .orderBy('date', descending: true)
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

  static Future<String> saveGas(
      bool checkin,
      String sampleType,
      String researcherId,
      String researchEmail,
      String labId,
      String date,
      String entryDate,
      String exitDate,
      String location,
      String storageCondition,
      String observation,
      String ecosystem,
      String gasType,
      String chamberType,
      String co2,
      String ch4,
      String no2,
      double? latitude,
      double? longitude,
      [String? previousSample,
      String? nextSample]) async {
    //, String user) async {
    final store = FirebaseFirestore.instance;

    // QuerySnapshot researcherDocRef = await FirebaseFirestore.instance
    //     .collection('researchers')
    //     .where('email', isEqualTo: user)
    //     .get();

    // final researcherDocs = researcherDocRef.docs;
    // final researcher = researcherDocs[0];
    // print(researcher);

    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('samples').doc();

    await docRef.set(
      {
        'checkin': checkin,
        'researcherId': researcherId,
        'researcherEmail': researchEmail,
        'labId': labId,
        'sampleType': sampleType,
        'date': date == ""
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(DateTime.now().toString()))
            : date,
        'entryDate': entryDate,
        'exitDate': exitDate,
        'location': location,
        'storageCondition': storageCondition,
        'observation': observation,
        'ecosystem': ecosystem,
        'gasType': gasType,
        'chamberType': chamberType,
        'co2': co2,
        'ch4': ch4,
        'no2': no2,
        'latitude': latitude,
        'longitude': longitude,
        'previousSample': previousSample ?? '',
        'nextSample': nextSample ?? '',
      },
    );

    return docRef.id;

    /*
    await store.collection('samples').add(
      {
        'researcherId': researcherId,
        'researcherEmail': researchEmail,
        'labId': labId,
        'sampleType': sampleType,
        'date': date,
        'entryDate': entryDate,
        'exitDate': exitDate,
        'location': location,
        'storageCondition': storageCondition,
        'observation': observation,
        'ecosystem': ecosystem,
        'gasType': gasType,
        'chamberType': chamberType,
        'co2': co2,
        'ch4': ch4,
        'no2': no2,
        'latitude': latitude,
        'longitude': longitude,
        'previousSample': previousSample ?? '',
        'nextSample': nextSample ?? '',
      },
    );
    */
  }

  static Future<String> saveSediment(
      bool checkin,
      String sampleType,
      String researcherId,
      String researchEmail,
      String labId,
      String date,
      String entryDate,
      String exitDate,
      String location,
      String storageCondition,
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
      double? longitude,
      [String? previousSample,
      String? nextSample]) async {
    //, String user) async {
    final store = FirebaseFirestore.instance;
    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('samples').doc();

    await docRef.set(
      {
        'checkin': checkin,
        'researcherId': researcherId,
        'researcherEmail': researchEmail,
        'labId': labId,
        'sampleType': sampleType,
        'date': date == ""
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(DateTime.now().toString()))
            : date,
        'entryDate': entryDate,
        'exitDate': exitDate,
        'location': location,
        'storageCondition': storageCondition,
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
        'longitude': longitude,
        'previousSample': previousSample ?? '',
        'nextSample': nextSample ?? '',
      },
    );

    return docRef.id;

    // QuerySnapshot researcherDocRef = await FirebaseFirestore.instance
    //     .collection('researchers')
    //     .where('email', isEqualTo: user)
    //     .get();

    // final researcherDocs = researcherDocRef.docs;
    // final researcher = researcherDocs[0];
    // print(researcher);

    /*
    await store.collection('samples').add(
      {
        'researcherId': researcherId,
        'researcherEmail': researchEmail,
        'labId': labId,
        'sampleType': sampleType,
        'date': date,
        'entryDate': entryDate,
        'exitDate': exitDate,
        'location': location,
        'storageCondition': storageCondition,
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
        'longitude': longitude,
        'previousSample': previousSample ?? '',
        'nextSample': nextSample ?? '',
      },
    ); */
  }

  static Future<String> saveWater(
      bool checkin,
      String sampleType,
      String researcherId,
      String researchEmail,
      String labId,
      String date,
      String entryDate,
      String exitDate,
      String location,
      String storageCondition,
      String observation,
      String ecosystem,
      String waterType,
      String co2,
      String ch4,
      String no2,
      double? latitude,
      double? longitude,
      [String? previousSample,
      String? nextSample]) async {
    //, String user) async {
    final store = FirebaseFirestore.instance;

    // QuerySnapshot researcherDocRef = await FirebaseFirestore.instance
    //     .collection('researchers')
    //     .where('email', isEqualTo: user)
    //     .get();

    // final researcherDocs = researcherDocRef.docs;
    // final researcher = researcherDocs[0];
    // print(researcher);

    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('samples').doc();

    await docRef.set(
      {
        'checkin': checkin,
        'researcherId': researcherId,
        'researcherEmail': researchEmail,
        'labId': labId,
        'sampleType': sampleType,
        'date': date == ""
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(DateTime.now().toString()))
            : date,
        'entryDate': entryDate,
        'exitDate': exitDate,
        'location': location,
        'storageCondition': storageCondition,
        'observation': observation,
        'ecosystem': ecosystem,
        'waterType': waterType,
        'co2': co2,
        'ch4': ch4,
        'no2': no2,
        'latitude': latitude,
        'longitude': longitude,
        'previousSample': previousSample ?? '',
        'nextSample': nextSample ?? '',
      },
    );

    return docRef.id;

    /*
    await store.collection('samples').add(
      {
        'researcherId': researcherId,
        'researcherEmail': researchEmail,
        'labId': labId,
        'sampleType': sampleType,
        'date': date,
        'entryDate': entryDate,
        'exitDate': exitDate,
        'location': location,
        'storageCondition': storageCondition,
        'observation': observation,
        'ecosystem': ecosystem,
        'waterType': waterType,
        'co2': co2,
        'ch4': ch4,
        'no2': no2,
        'latitude': latitude,
        'longitude': longitude,
        'previousSample': previousSample ?? '',
        'nextSample': nextSample ?? '',
      },
    ); */
  }

  static Future<String> save(
      String sampleType,
      String researcherId,
      String researchEmail,
      String labId,
      String date,
      String entryDate,
      String exitDate,
      String location,
      String storageCondition,
      String observation,
      String ecosystem,
      double? latitude,
      double? longitude,
      [String? previousSample,
      String? nextSample]) async {
    //, String user) async {
    final store = FirebaseFirestore.instance;

    // QuerySnapshot researcherDocRef = await FirebaseFirestore.instance
    //     .collection('researchers')
    //     .where('email', isEqualTo: user)
    //     .get();

    // final researcherDocs = researcherDocRef.docs;
    // final researcher = researcherDocs[0];
    // print(researcher);

    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('samples').doc();

    await docRef.set({
      'researcherId': researcherId,
      'researcherEmail': researchEmail,
      'labId': labId,
      'sampleType': sampleType,
      'date': date == ""
          ? DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(DateTime.now().toString()))
          : date,
      'entryDate': entryDate,
      'exitDate': exitDate,
      'location': location,
      'storageCondition': storageCondition,
      'observation': observation,
      'ecosystem': ecosystem,
      'latitude': latitude,
      'longitude': longitude,
      'previousSample': previousSample ?? '',
      'nextSample': nextSample ?? '',
    });

    return docRef.id;

    /*
    await store.collection('samples').add(
      {
        'researcherId': researcherId,
        'researcherEmail': researchEmail,
        'labId': labId,
        'sampleType': sampleType,
        'date': date,
        'entryDate': entryDate,
        'exitDate': exitDate,
        'location': location,
        'storageCondition': storageCondition,
        'observation': observation,
        'ecosystem': ecosystem,
        'latitude': latitude,
        'longitude': longitude,
        'previousSample': previousSample ?? '',
        'nextSample': nextSample ?? '',
      },
    );
    */
  }
}
