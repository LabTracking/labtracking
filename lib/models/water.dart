import 'package:labtracking/models/sample.dart';

class Water extends Sample {
  String? name = "water";

  @override
  String getName() {
    return name!;
  }
}
