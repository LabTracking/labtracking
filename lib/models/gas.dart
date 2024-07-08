import 'package:labtracking/models/sample.dart';

class Gas extends Sample {
  String? name = "gas";
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
  String? gasType;
  String? chamberType;
  String? co2;
  String? ch4;
  String? no2;
  double? latitude;
  double? longitude;
  final List<Sample> samples;

  Gas({
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
    this.gasType,
    this.chamberType,
    this.co2,
    this.ch4,
    this.no2,
    this.latitude,
    this.longitude,
    required this.samples,
  });

  void addGas(Gas gas) {
    samples.add(gas);
  }

  @override
  String getName() {
    return name!;
  }
}
