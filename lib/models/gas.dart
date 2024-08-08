import 'package:labtracking/models/sample.dart';

class Gas extends Sample {
  String? name = "gas";
  String? id;
  bool? checkin;
  String? sampleType;
  String? researcherId;
  String? researchEmail;
  String? labId;
  String? date;
  String? entryDate;
  String? exitDate;
  String? location;
  String? storageCondition;
  String? observation;
  String? ecosystem;
  String? gasType;
  String? chamberType;
  String? co2;
  String? ch4;
  String? no2;
  double? latitude;
  double? longitude;
  List<Sample>? samples;
  int? level;
  String? fatherId;

  Gas(
      {this.checkin,
      this.id,
      this.sampleType,
      this.researcherId,
      this.researchEmail,
      this.labId,
      this.date,
      this.entryDate,
      this.exitDate,
      this.location,
      this.storageCondition,
      this.observation,
      this.ecosystem,
      this.gasType,
      this.chamberType,
      this.co2,
      this.ch4,
      this.no2,
      this.latitude,
      this.longitude,
      this.samples,
      this.level,
      this.fatherId});

  @override
  String getName() {
    return sampleType!;
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
      'researchEmail': researchEmail,
      'labId': labId,
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
      //'samples': samples.map((sample) => sample.toMap()).toList(),
      'level': level
    };
  }

  @override
  Sample fromMap(Map<String, dynamic> map) {
    return Gas(
        id: map['id'],
        checkin: map['checkin'],
        sampleType: map['sampleType'],
        researcherId: map['researcherId'],
        researchEmail: map['researchEmail'],
        labId: map['labId'],
        date: map['date'],
        entryDate: map['entryDate'],
        exitDate: map['exitDate'],
        location: map['location'],
        storageCondition: map['storageCondition'],
        observation: map['observation'],
        ecosystem: map['ecosystem'],
        gasType: map['gasType'],
        chamberType: map['chamberType'],
        co2: map['co2'],
        ch4: map['ch4'],
        no2: map['no2'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        // Assuming `samples` are not included in the map for simplicity
        samples: [], // Placeholder, load samples separately if needed
        level: map['level']);
  }
}
