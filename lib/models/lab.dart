import 'package:flutter/foundation.dart';
import 'package:labtracking/models/researcher.dart';

class Lab with ChangeNotifier {
  final String id;
  final String name;
  final List<String> leaders;
  List<Researcher> members = [];
  List<dynamic> samples = [];

  Researcher? createdBy;

  Lab({
    required this.id,
    required this.name,
    required this.leaders,
  });

  void addResearcher(Researcher researcher) {
    members.add(researcher);
    notifyListeners();
  }

  void addSample(dynamic sample) {
    samples.add(sample);
    notifyListeners();
  }
}
