import 'package:labtracking/models/sample.dart';

class Sediment extends Sample {
  String? name = 'sediment';
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
  String? remineralization;
  String? co2;
  String? ch4;
  String? no2;
  String? sand;
  String? silt;
  String? clay;
  String? n;
  String? delta13c;
  String? delta15n;
  String? density;
  double? latitude;
  double? longitude;
  final List<Sample> samples;

  Sediment({
    this.checkin,
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
    this.remineralization,
    this.co2,
    this.ch4,
    this.no2,
    this.sand,
    this.silt,
    this.clay,
    this.n,
    this.delta13c,
    this.delta15n,
    this.density,
    this.latitude,
    this.longitude,
    required this.samples,
  });

  @override
  String getName() {
    return name!;
  }
}
