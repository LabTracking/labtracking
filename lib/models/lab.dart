import 'package:labtracking/models/researcher.dart';

class Lab {
  final String name;
  final Researcher leader;
  List<Researcher> members = [];
  List<dynamic> samples = [];

  Lab({required this.name, required this.leader});

  void addResearcher(Researcher researcher) {
    members.add(researcher);
  }

  void addSample(dynamic sample) {
    samples.add(sample);
  }
}
