import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/models/gas.dart';
import 'package:labtracking/models/researcher.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/models/sediment.dart';
import 'package:labtracking/models/water.dart';

class NewSampleService {
  // Map<String, dynamic> fromFirestore(
  //     DocumentSnapshot doc, SnapshotOptions? options) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return {
  //     'checkin': data['checkin'],
  //     'sampleType': data['sampleType'],
  //     'researcherId': data['researcherId'],
  //     'researchEmail': data['researchEmail'],
  //     'labId': data['labId'],
  //     'date': data['date'],
  //     'entryDate': data['entryDate'],
  //     'exitDate': data['exitDate'],
  //     'location': data['location'],
  //     'storageCondition': data['storageCondition'],
  //     'observation': data['observation'],
  //     'ecosystem': data['ecosystem'],
  //     'gasType': data['gasType'],
  //     'chamberType': data['chamberType'],
  //     'co2': data['co2'],
  //     'ch4': data['ch4'],
  //     'no2': data['no2'],
  //     'latitude': data['latitude'],
  //     'longitude': data['longitude'],
  //     'samples': List<String>.from(data['samples']),
  //   };
  // }

  // Map<String, Object?> toFirestore(
  //     Map<String, dynamic> data, SetOptions? options) {
  //   return {
  //     'checkin': data['checkin'],
  //     'sampleType': data['sampleType'],
  //     'researcherId': data['researcherId'],
  //     'researchEmail': data['researchEmail'],
  //     'labId': data['labId'],
  //     'date': data['date'],
  //     'entryDate': data['entryDate'],
  //     'exitDate': data['exitDate'],
  //     'location': data['location'],
  //     'storageCondition': data['storageCondition'],
  //     'observation': data['observation'],
  //     'ecosystem': data['ecosystem'],
  //     'gasType': data['gasType'],
  //     'chamberType': data['chamberType'],
  //     'co2': data['co2'],
  //     'ch4': data['ch4'],
  //     'no2': data['no2'],
  //     'latitude': data['latitude'],
  //     'longitude': data['longitude'],
  //     'samples': data['samples'],
  //   };
  // }
  Map<String, dynamic> toFirestore(
    Sample sample,
    SetOptions? options,
  ) {
    return {
      'checkin': sample.checkin,
      'sampleType': sample.sampleType,
      'researcherId': sample.researcherId,
      'researchEmail': sample.researchEmail,
      'labId': sample.labId,
      'date': sample.date,
      'entryDate': sample.entryDate,
      'exitDate': sample.exitDate,
      'location': sample.location,
      'storageCondition': sample.storageCondition,
      'observation': sample.observation,
      'ecosystem': sample.ecosystem,
      'gasType': sample.gasType,
      'chamberType': sample.chamberType,
      'co2': sample.co2,
      'ch4': sample.ch4,
      'no2': sample.no2,
      'latitude': sample.latitude,
      'longitude': sample.longitude,
      'samples': sample.samples,
    };
  }

  // Map<String, dynamic> => Sample
  Sample fromFirestore(DocumentSnapshot doc, SnapshotOptions? options) {
    final data = doc.data() as Map<String, dynamic>;
    print("AQUI*********************" + data.toString());
    Sample? sample;

    if (data['sampleType'] == "gas") {
      sample = Gas(
        checkin: data['checkin'],
        sampleType: data['sampleType'],
        researcherId: data['researcherId'],
        researchEmail: data['researcherEmail'],
        labId: data['labId'],
        date: data['date'],
        entryDate: data['entryDate'],
        exitDate: data['exitDate'],
        location: data['location'],
        storageCondition: data['storageCondition'],
        observation: data['observation'],
        ecosystem: data['ecosystem'],
        gasType: data['gasType'],
        chamberType: data['chamberType'],
        co2: data['co2'],
        ch4: data['ch4'],
        no2: data['no2'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        samples: List<Sample>.from(data['samples'] ?? []),
      );
    } else if (data['sampleType'] == "sediment") {
      sample = Sediment(
        checkin: data['checkin'],
        sampleType: data['sampleType'],
        researcherId: data['researcherId'],
        researchEmail: data['researcherEmail'],
        labId: data['labId'],
        date: data['date'],
        entryDate: data['entryDate'],
        exitDate: data['exitDate'],
        location: data['location'],
        storageCondition: data['storageCondition'],
        observation: data['observation'],
        ecosystem: data['ecosystem'],
        remineralization: data['remineralization'],
        co2: data['co2'],
        ch4: data['ch4'],
        no2: data['no2'],
        sand: data['sand'],
        silt: data['silt'],
        clay: data['clay'],
        delta13c: data['delta13c'],
        delta15n: data['delta15n'],
        density: data['density'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        samples: List<Sample>.from(data['samples'] ?? []),
      );
    } else {
      sample = Water(
        checkin: data['checkin'],
        sampleType: data['sampleType'],
        researcherId: data['researcherId'],
        researchEmail: data['researcherEmail'],
        labId: data['labId'],
        date: data['date'],
        entryDate: data['entryDate'],
        exitDate: data['exitDate'],
        location: data['location'],
        storageCondition: data['storageCondition'],
        observation: data['observation'],
        ecosystem: data['ecosystem'],
        waterType: data['waterType'],
        co2: data['co2'],
        ch4: data['ch4'],
        no2: data['no2'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        samples: List<Sample>.from(data['samples'] ?? []),
      );
    }

    print(sample!.getName());
    return sample;
  }

  //Stream<List<Map<String, dynamic>>> samplesStream() {
  Stream<List<Sample>> samplesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('samples')
        .withConverter<Sample>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        )
        .orderBy('date', descending: true)
        .snapshots();

    return snapshots.map((snapshot) {
      try {
        var sampleList = snapshot.docs.map((doc) {
          return doc.data();
        }).toList();
        print("===== Sample list =====");
        for (var sample in sampleList) {
          print("Lab ID: ${sample.labId}");
        }
        print("===== Sample list =====");
        return sampleList;
      } catch (e, stackTrace) {
        print('Error processing snapshot: $e');
        print(stackTrace);
        return []; // Return empty list or handle error case as needed
      }
    });
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
      [List? samples]) async {
    // [String? previousGas,
    // String? nextSample]) async {
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
        'samples': samples ?? [],
        //'previousSample': previousSample ?? '',
        //'nextSample': nextSample ?? '',
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
      [List? samples]) async {
    //[String? previousSample,
    //String? nextSample]) async {
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
        'samples': samples ?? [],
        //'previousSample': previousSample ?? '',
        //'nextSample': nextSample ?? '',
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
      [List? samples]) async {
    // [String? previousSample,
    //String? nextSample]) async {
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
        'samples': samples ?? [],
        //'previousSample': previousSample ?? '',
        //'nextSample': nextSample ?? '',
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
