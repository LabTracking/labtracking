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
      gasType: sampleData['gasType'],
      chamberType: sampleData['chamberType'],
      co2: sampleData['co2'],
      ch4: sampleData['ch4'],
      no2: sampleData['no2'],
      latitude: sampleData['latitude'],
      longitude: sampleData['longitude'],
      level: sampleData['level'],
      fatherId: sampleData['fatherId'],
      samples: (sampleData['samples'] as List<dynamic>? ?? [])
          .map((item) => convertToSample(item as Map<String, dynamic>))
          .toList(),
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
      remineralization: sampleData['remineralization'],
      co2: sampleData['co2'],
      ch4: sampleData['ch4'],
      no2: sampleData['no2'],
      sand: sampleData['sand'],
      silt: sampleData['silt'],
      clay: sampleData['clay'],
      delta13c: sampleData['delta13c'],
      delta15n: sampleData['delta15n'],
      density: sampleData['density'],
      latitude: sampleData['latitude'],
      longitude: sampleData['longitude'],
      samples: sampleData['samples'].map((sample) => sample.toMap()),
    );
  } else {
    return Water(
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
      waterType: sampleData['waterType'],
      co2: sampleData['co2'],
      ch4: sampleData['ch4'],
      no2: sampleData['no2'],
      latitude: sampleData['latitude'],
      longitude: sampleData['longitude'],
      samples: (sampleData['samples'] as List<dynamic>? ?? [])
          .map((item) => convertToSample(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
