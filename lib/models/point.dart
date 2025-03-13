import 'package:flutter/widgets.dart';
import 'dart:io';

class Coords with ChangeNotifier {
  double? lat;
  double? long;

  Coords({
    this.lat,
    this.long,
  });

  void changeCoordinates(double lat, double long) {
    this.lat = lat;
    this.long = long;
    notifyListeners();
  }
}
