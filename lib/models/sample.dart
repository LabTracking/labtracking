abstract class Sample {
  String? name;
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
  final List? samples;

  Sample({
    this.checkin,
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
  });

  String getName();
  void addSample(Sample sample);
  Map<String, dynamic> toMap();
  Sample fromMap(Map<String, dynamic> map);
}
