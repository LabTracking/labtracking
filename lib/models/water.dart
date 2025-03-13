import 'package:labtracking/models/sample.dart';

class Water extends Sample {
  String? name = 'water';
  String? id;
  bool? checkin;
  String? sampleType;
  String? researcherId;
  String? researcherEmail;
  String? labId;
  String? date;
  String? entryDate;
  String? exitDate;
  String? location;
  String? storageCondition;
  String? observation;
  String? ecosystem;
  // String? remineralization;
  // String? co2;
  // String? ch4;
  // String? no2;
  // String? sand;
  // String? silt;
  // String? clay;
  // String? n;
  // String? delta13c;
  // String? delta15n;
  // String? density;
  double? latitude;
  double? longitude;
  List<Sample>? samples;
  int? level;
  String? fatherId;
  String? originalSampleId;

  bool? exists;

  String? sampleName;

  String? provider;

  List? storageTemperature;

  List<Map<dynamic, dynamic>>? analysis;

  List? sonIds;

  String? weight;

  Water({
    this.checkin,
    this.id,
    this.sampleType,
    this.researcherId,
    this.researcherEmail,
    this.labId,
    this.date,
    this.entryDate,
    this.exitDate,
    this.location,
    this.storageCondition,
    this.observation,
    this.ecosystem,
    // this.remineralization,
    // this.co2,
    // this.ch4,
    // this.no2,
    // this.sand,
    // this.silt,
    // this.clay,
    // this.n,
    // this.delta13c,
    // this.delta15n,
    // this.density,
    this.latitude,
    this.longitude,
    this.samples,
    this.level,
    this.fatherId,
    this.originalSampleId,
    this.exists,
    this.sampleName,
    this.provider,
    this.storageTemperature,
    this.analysis,
    this.sonIds,
    this.weight,
  });

  @override
  String getName() {
    return name!;
  }

  @override
  void addSample(Sample sample) {
    samples!.add(sample);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'checkin': checkin,
      'sampleType': sampleType,
      'researcherId': researcherId,
      'researcherEmail': researcherEmail,
      'labId': labId,
      'date': date,
      'entryDate': entryDate,
      'exitDate': exitDate,
      'location': location,
      'storageCondition': storageCondition,
      'observation': observation,
      'ecosystem': ecosystem,
      'latitude': latitude,
      'longitude': longitude,
      'samples': samples!.map((gas) => gas.toMap()).toList(),
      'level': level,
      'fatherId': fatherId,
      'originalSampleId': originalSampleId,
      'exists': exists,
      'sampleName': sampleName,
      'provider': provider,
      'storageTemperature': storageTemperature,
      'analysis': analysis,
      'sonIds': sonIds,
      'weight': weight,
    };
  }

  @override
  Sample fromMap(Map<String, dynamic> map) {
    return Water(
      id: map['id'],
      checkin: map['checkin'],
      sampleType: map['sampleType'],
      researcherId: map['researcherId'],
      researcherEmail: map['researcherEmail'],
      labId: map['labId'],
      date: map['date'],
      entryDate: map['entryDate'],
      exitDate: map['exitDate'],
      location: map['location'],
      storageCondition: map['storageCondition'],
      observation: map['observation'],
      ecosystem: map['ecosystem'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      // Assuming `samples` are not included in the map for simplicity
      samples: [], // Placeholder, load samples separately if needed
      level: map['level'],
      fatherId: map['fatherId'],
      originalSampleId: map['originalSampleId'],
      sampleName: map['sampleName'],
      provider: map['provider'],
      storageTemperature: map['storageTemperature'].toList(),
      analysis: map['analysis'],
      sonIds: map['sonIds'].toList(),
      weight: map['weight'],
    );
  }
}
