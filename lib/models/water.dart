import 'package:labtracking/models/sample.dart';

class Water extends Sample {
  String? name = "water";
  String id = '';
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
  final List<Sample> samples;

  Water({
    bool? checkin,
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
    required this.samples,
  });

  @override
  String getName() {
    return name!;
  }

  @override
  void addSample(Sample sample) {
    samples.add(sample);
  }
}
