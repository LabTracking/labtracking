abstract class Sample {
  String? name;
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
  //String? gasType;
  //String? chamberType;
  //String? co2;
  //String? ch4;
  //String? no2;
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

  Sample({
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
    //this.gasType,
    //this.chamberType,
    //this.co2,
    //this.ch4,
    //this.no2,
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

  Map<String, dynamic> toMap() {
    return {
      "checkin": checkin,
      "id": id,
      "sampleType": sampleType,
      "researcherId": researcherId,
      "researcherEmail": researcherEmail,
      "labId": labId,
      "date": date,
      "entryDate": entryDate,
      "exitDate": exitDate,
      "location": location,
      "storageCondition": storageCondition,
      "observation": observation,
      "ecosystem": ecosystem,
      //"gasType": gasType,
      //"chamberType": chamberType,
      //"co2": co2,
      //"ch4": ch4,
      //"no2": no2,
      "latitude": latitude,
      "longitude": longitude,
      'samples': samples!.map((sample) => sample.toMap()).toList(),
      "level": level,
      "fatherId": fatherId,
      "originalSampleId": originalSampleId,
      'exists': exists,
      'sampleName': sampleName,
      'provider': provider,
      'storageTemperature': storageTemperature,
      'analysis': analysis,
      'sonIds': sonIds,
      'weight': weight,
    };
  }

  String getName();
  void addSample(Sample sample);
  Sample fromMap(Map<String, dynamic> map);
}
