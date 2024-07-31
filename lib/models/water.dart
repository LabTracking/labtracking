import 'package:labtracking/models/sample.dart';

class Water extends Sample {
  String? name = "water";
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
  String? waterType;
  String? co2;
  String? ch4;
  String? no2;
  double? latitude;
  double? longitude;
  List? samples;

  Water({
    bool? checkin,
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
    this.waterType,
    this.co2,
    this.ch4,
    this.no2,
    this.latitude,
    this.longitude,
    this.samples,
  });

  @override
  String getName() {
    return name!;
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
    };
  }

  @override
  void addSample(Sample sample) {
    samples!.add(sample);
  }
}
