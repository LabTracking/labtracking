import 'package:labtracking/models/sample.dart';

class Sediment extends Sample {
  String? name = 'sediment';

  @override
  String getName() {
    return name!;
  }
}
