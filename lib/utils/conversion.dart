import 'package:labtracking/models/gas.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/models/sediment.dart';
import 'package:labtracking/models/water.dart';

Sample convertToSample(Map<String, dynamic> sampleData) {
  String sampleType = sampleData['sampleType'];

  if (sampleType == "gas") {
    return Gas(
      id: sampleData['id'],
      checkin: sampleData['checkin'],
      sampleType: sampleData['sampleType'],
      researcherId: sampleData['researcherId'],
      researcherEmail: sampleData['researcherEmail'],
      labId: sampleData['labId'],
      date: sampleData['date'],
      entryDate: sampleData['entryDate'],
      exitDate: sampleData['exitDate'],
      location: sampleData['location'],
      storageCondition: sampleData['storageCondition'],
      observation: sampleData['observation'],
      ecosystem: sampleData['ecosystem'],
      // gasType: sampleData['gasType'],
      // chamberType: sampleData['chamberType'],
      // co2: sampleData['co2'],
      // ch4: sampleData['ch4'],
      // no2: sampleData['no2'],
      latitude: sampleData['latitude'],
      longitude: sampleData['longitude'],
      level: sampleData['level'],
      fatherId: sampleData['fatherId'],
      originalSampleId: sampleData['originalSampleId'],
      samples: (sampleData['samples'] as List<dynamic>? ?? [])
          .map((item) => convertToSample(item as Map<String, dynamic>))
          .toList(),
      exists: sampleData['exists'],
      sampleName: sampleData['sampleName'],
      provider: sampleData['provider'],
      storageTemperature:
          (sampleData['storageTemperature'] as List<dynamic>? ?? [])
              .map((item) => item as Map<String, dynamic>)
              .toList(),
      analysis: (sampleData['analysis'] as List<dynamic>? ?? [])
          .map((item) => item as Map<String, dynamic>)
          .toList(),
      sonIds: (sampleData['sonIds'] as List? ?? [])
          .map((item) => item as String)
          .toList(),
      weight: sampleData['weight'],
    );
  } else if (sampleType == "sediment") {
    return Sediment(
      id: sampleData['id'],
      checkin: sampleData['checkin'],
      sampleType: sampleData['sampleType'],
      researcherId: sampleData['researcherId'],
      researcherEmail: sampleData['researcherEmail'],
      labId: sampleData['labId'],
      date: sampleData['date'],
      entryDate: sampleData['entryDate'],
      exitDate: sampleData['exitDate'],
      location: sampleData['location'],
      storageCondition: sampleData['storageCondition'],
      observation: sampleData['observation'],
      ecosystem: sampleData['ecosystem'],
      // remineralization: sampleData['remineralization'],
      // co2: sampleData['co2'],
      // ch4: sampleData['ch4'],
      // no2: sampleData['no2'],
      // sand: sampleData['sand'],
      // silt: sampleData['silt'],
      // clay: sampleData['clay'],
      // delta13c: sampleData['delta13c'],
      // delta15n: sampleData['delta15n'],
      // density: sampleData['density'],
      latitude: sampleData['latitude'],
      longitude: sampleData['longitude'],
      level: sampleData['level'],
      fatherId: sampleData['fatherId'],
      originalSampleId: sampleData['originalSampleId'],
      samples: (sampleData['samples'] as List<dynamic>? ?? [])
          .map((item) => convertToSample(item as Map<String, dynamic>))
          .toList(),
      exists: sampleData['exists'],
      sampleName: sampleData['sampleName'],
      provider: sampleData['provider'],
      storageTemperature:
          (sampleData['storageTemperature'] as List<dynamic>? ?? [])
              .map((item) => item as Map<String, dynamic>)
              .toList(),

      analysis: (sampleData['analysis'] as List<dynamic>? ?? [])
          .map((item) => item as Map<String, dynamic>)
          .toList(),
      sonIds: (sampleData['sonIds'] as List? ?? [])
          .map((item) => item as String)
          .toList(),

      weight: sampleData['weight'],
    );
  } else {
    return Water(
      id: sampleData['id'],
      checkin: sampleData['checkin'],
      sampleType: sampleData['sampleType'],
      researcherId: sampleData['researcherId'],
      researcherEmail: sampleData['researcherEmail'],
      labId: sampleData['labId'],
      date: sampleData['date'],
      entryDate: sampleData['entryDate'],
      exitDate: sampleData['exitDate'],
      location: sampleData['location'],
      storageCondition: sampleData['storageCondition'],
      observation: sampleData['observation'],
      ecosystem: sampleData['ecosystem'],
      latitude: sampleData['latitude'],
      longitude: sampleData['longitude'],
      level: sampleData['level'],
      fatherId: sampleData['fatherId'],
      originalSampleId: sampleData['originalSampleId'],
      samples: (sampleData['samples'] as List<dynamic>? ?? [])
          .map((item) => convertToSample(item as Map<String, dynamic>))
          .toList(),
      exists: sampleData['exists'],
      sampleName: sampleData['sampleName'],
      provider: sampleData['provider'],
      storageTemperature:
          (sampleData['storageTemperature'] as List<dynamic>? ?? [])
              .map((item) => item as Map<String, dynamic>)
              .toList(),
      analysis: (sampleData['analysis'] as List<dynamic>? ?? [])
          .map((item) => item as Map<String, dynamic>)
          .toList(),
      sonIds: (sampleData['sonIds'] as List? ?? [])
          .map((item) => item as String)
          .toList(),
      weight: sampleData['weight'],
    );
  }
}
