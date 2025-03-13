import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import '../utils/conversion.dart';

import 'package:labtracking/models/sample.dart';
import 'package:labtracking/models/sediment.dart';
import 'package:labtracking/models/water.dart';
import 'package:labtracking/models/gas.dart';

class NewSampleService {
  Map<String, dynamic> toFirestore(
    Sample sample,
    SetOptions? options,
  ) {
    return {
      'checkin': sample.checkin,
      'sampleType': sample.sampleType,
      'researcherId': sample.researcherId,
      'researcherEmail': sample.researcherEmail,
      'labId': sample.labId,
      'date': sample.date,
      'entryDate': sample.entryDate,
      'exitDate': sample.exitDate,
      'location': sample.location,
      'storageCondition': sample.storageCondition,
      'observation': sample.observation,
      'ecosystem': sample.ecosystem,
      // 'gasType': sample.gasType,
      // 'chamberType': sample.chamberType,
      // 'co2': sample.co2,
      // 'ch4': sample.ch4,
      // 'no2': sample.no2,
      'latitude': sample.latitude,
      'longitude': sample.longitude,
      'samples': sample.samples,
      'level': sample.level,
      'exists': sample.exists,
      'sampleName': sample.sampleName,
      'provider': sample.provider,
      'storageTemperature': sample.storageTemperature,
      'analysis': sample.analysis,
      'sonIds': sample.sonIds,
      'weight': sample.weight,
    };
  }

  // Map<String, dynamic> => Sample
  Sample fromFirestore(DocumentSnapshot doc, SnapshotOptions? options) {
    final data = doc.data() as Map<String, dynamic>;
    print("AQUI*********************" + data.toString());
    Sample? sample;

    if (data['sampleType'] == "gas") {
      sample = Gas(
        id: doc.id,
        checkin: data['checkin'],
        sampleType: data['sampleType'],
        researcherId: data['researcherId'],
        researcherEmail: data['researcherEmail'],
        labId: data['labId'],
        date: data['date'],
        entryDate: data['entryDate'],
        exitDate: data['exitDate'],
        location: data['location'],
        storageCondition: data['storageCondition'] ?? "Other" ?? "Other",
        observation: data['observation'],
        ecosystem: data['ecosystem'],
        // gasType: data['gasType'],
        // chamberType: data['chamberType'],
        // co2: data['co2'],
        // ch4: data['ch4'],
        // no2: data['no2'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        level: data['level'],
        samples: (data['samples'] as List<dynamic>? ?? [])
            .map((item) => convertToSample(item as Map<String, dynamic>))
            .toList(),
        exists: data['exists'],
        sampleName: data['sampleName'],
        provider: data['provider'],
        storageTemperature: (data['storageTemperature'] as List<dynamic>? ?? [])
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        analysis: (data['analysis'] as List<dynamic>? ?? [])
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        sonIds: (data['sonIds'] as List? ?? [])
            .map((item) => item as String)
            .toList(),
        weight: data['weight'],
      );
    } else if (data['sampleType'] == "sediment") {
      sample = Sediment(
        id: doc.id,
        checkin: data['checkin'],
        sampleType: data['sampleType'],
        researcherId: data['researcherId'],
        researcherEmail: data['researcherEmail'],
        labId: data['labId'],
        date: data['date'],
        entryDate: data['entryDate'],
        exitDate: data['exitDate'],
        location: data['location'],
        storageCondition: data['storageCondition'] ?? "Other",
        observation: data['observation'],
        ecosystem: data['ecosystem'],
        // remineralization: data['remineralization'],
        // co2: data['co2'],
        // ch4: data['ch4'],
        // no2: data['no2'],
        // sand: data['sand'],
        // silt: data['silt'],
        // clay: data['clay'],
        // delta13c: data['delta13c'],
        // delta15n: data['delta15n'],
        // density: data['density'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        level: data['level'],
        samples: (data['samples'] as List<dynamic>? ?? [])
            .map((item) => convertToSample(item as Map<String, dynamic>))
            .toList(),
        exists: data['exists'],
        sampleName: data['sampleName'],
        provider: data['provider'],
        storageTemperature: (data['storageTemperature'] as List<dynamic>? ?? [])
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        analysis: (data['analysis'] as List<dynamic>? ?? [])
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        sonIds: (data['sonIds'] as List? ?? [])
            .map((item) => item as String)
            .toList(),
        weight: data['weight'],
      );
    } else {
      sample = Water(
        id: doc.id,
        checkin: data['checkin'],
        sampleType: data['sampleType'],
        researcherId: data['researcherId'],
        researcherEmail: data['researcherEmail'],
        labId: data['labId'],
        date: data['date'],
        entryDate: data['entryDate'],
        exitDate: data['exitDate'],
        location: data['location'],
        storageCondition: data['storageCondition'] ?? "Other",
        observation: data['observation'],
        ecosystem: data['ecosystem'],
        // gasType: data['gasType'],
        // chamberType: data['chamberType'],
        // co2: data['co2'],
        // ch4: data['ch4'],
        // no2: data['no2'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        level: data['level'],
        samples: (data['samples'] as List<dynamic>? ?? [])
            .map((item) => convertToSample(item as Map<String, dynamic>))
            .toList(),
        exists: data['exists'],
        sampleName: data['sampleName'],
        provider: data['provider'],
        storageTemperature: (data['storageTemperature'] as List<dynamic>? ?? [])
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        analysis: (data['analysis'] as List<dynamic>? ?? [])
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        sonIds: (data['sonIds'] as List? ?? [])
            .map((item) => item as String)
            .toList(),
        weight: data['weight'],
      );
    }

    return sample;
  }

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
    String researcherEmail,
    String labId,
    String date,
    String entryDate,
    String exitDate,
    String location,
    String storageCondition,
    String observation,
    String ecosystem,
    // String gasType,
    // String chamberType,
    // String co2,
    // String ch4,
    // String no2,
    double? latitude,
    double? longitude,
    int? level,
    String sampleName,
    String provider,
    String? weight,
    List? storageTemperature,
    List? analysis, [
    List? samples,
    bool? exists = true,
    List? sonIds,
  ]) async {
    final store = FirebaseFirestore.instance;

    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('samples').doc();

    await docRef.set(
      {
        'checkin': checkin,
        'researcherId': researcherId,
        'researcherEmail': researcherEmail,
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
        // 'gasType': gasType,
        // 'chamberType': chamberType,
        // 'co2': co2,
        // 'ch4': ch4,
        // 'no2': no2,
        'latitude': latitude,
        'longitude': longitude,
        'level': level,
        'samples': samples ?? [],
        'exists': exists,
        'sampleName': sampleName,
        'provider': provider,
        //'previousSample': previousSample ?? '',
        //'nextSample': nextSample ?? '',
        'storageTemperature': storageTemperature,
        'analysis': analysis ?? [],
        'sonIds': sonIds ?? [],
        'weight': weight ?? "",
      },
    );

    return docRef.id;
  }

  static Future<String> saveSediment(
    bool checkin,
    String sampleType,
    String researcherId,
    String researcherEmail,
    String labId,
    String date,
    String entryDate,
    String exitDate,
    String location,
    String storageCondition,
    String observation,
    String ecosystem,
    // String remineralization,
    // String co2,
    // String ch4,
    // String no2,
    // String sand,
    // String silt,
    // String clay,
    // String n,
    // String delta13c,
    // String delta15n,
    // String density,
    double? latitude,
    double? longitude,
    int? level,
    String sampleName,
    String provider,
    String? weight,
    List? storageTemperature,
    List? analysis, [
    List? samples,
    bool? exists = true,
    List? sonIds,
  ]) async {
    final store = FirebaseFirestore.instance;
    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('samples').doc();

    await docRef.set(
      {
        'checkin': checkin,
        'researcherId': researcherId,
        'researcherEmail': researcherEmail,
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
        // 'remineralization': remineralization,
        // 'co2': co2,
        // 'ch4': ch4,
        // 'no2': no2,
        // 'sand': sand,
        // 'silt': silt,
        // 'clay': clay,
        // 'n': n,
        // 'delta13c': delta13c,
        // 'delta15n': delta15n,
        // 'density': density,
        'latitude': latitude,
        'longitude': longitude,
        'level': level,
        'samples': samples ?? [],
        'exists': exists,
        'sampleName': sampleName,
        'provider': provider,
        //'previousSample': previousSample ?? '',
        //'nextSample': nextSample ?? '',
        'storageTemperature': storageTemperature,
        'analysis': analysis ?? [],
        'sonIds': sonIds ?? [],
        'weight': weight ?? "",
      },
    );

    return docRef.id;
  }

  static Future<String> saveWater(
    bool checkin,
    String sampleType,
    String researcherId,
    String researcherEmail,
    String labId,
    String date,
    String entryDate,
    String exitDate,
    String location,
    String storageCondition,
    String observation,
    String ecosystem,
    // String waterType,
    // String co2,
    // String ch4,
    // String no2,
    double? latitude,
    double? longitude,
    int? level,
    String sampleName,
    String provider,
    String? weight,
    List? storageTemperature,
    List? analysis, [
    List? samples,
    bool? exists = true,
    List? sonIds,
  ]) async {
    // [String? previousSample,
    //String? nextSample]) async {
    //, String user) async {
    final store = FirebaseFirestore.instance;

    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('samples').doc();

    await docRef.set(
      {
        'checkin': checkin,
        'researcherId': researcherId,
        'researcherEmail': researcherEmail,
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
        // 'waterType': waterType,
        // 'co2': co2,
        // 'ch4': ch4,
        // 'no2': no2,
        'latitude': latitude,
        'longitude': longitude,

        'level': level,
        'samples': samples ?? [],
        'exists': exists,
        'sampleName': sampleName,
        'provider': provider,
        //'previousSample': previousSample ?? '',
        //'nextSample': nextSample ?? '',
        'storageTemperature': storageTemperature,
        'analysis': analysis ?? [],
        'sonIds': sonIds ?? [],
        'weight': weight ?? "",
      },
    );

    return docRef.id;
  }

  static Future<String> save(
      String sampleType,
      String researcherId,
      String researcherEmail,
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
      'researcherEmail': researcherEmail,
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
        'researcherEmail': researcherEmail,
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

  static Future<void> saveSampleEdits(String mainSampleId, String sampleId,
      Map<String, dynamic> updatedData) async {
    // Busca a amostra principal pelo ID
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('samples')
        .doc(mainSampleId)
        .get();

    // Verifica se a amostra principal existe
    if (!snapshot.exists) {
      print("Amostra principal não encontrada!");
      return;
    }

    // Recupera os dados da amostra principal
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    // Função auxiliar para encontrar a subamostra pelo ID
    bool updateSubSample(List<dynamic> children) {
      for (var child in children) {
        if (child['id'] == sampleId) {
          // Se a subamostra for encontrada, atualize-a
          child.addAll(updatedData); // Adiciona os dados atualizados
          return true;
        }
        // Se não encontrado, verifique recursivamente nos filhos
        if (child['samples'] != null && updateSubSample(child['samples'])) {
          return true;
        }
      }
      return false;
    }

    // Tenta atualizar a subamostra
    if (updateSubSample(data['samples'])) {
      // Salva as alterações na amostra principal
      await FirebaseFirestore.instance
          .collection('samples')
          .doc(mainSampleId)
          .update(data);
      print("Amostra atualizada com sucesso!");
    } else {
      print("Subamostra não encontrada!");
    }
  }
}
