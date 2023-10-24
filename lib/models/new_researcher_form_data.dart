import 'package:flutter/material.dart';

class NewResearcherFormData with ChangeNotifier {
  String name = '';
  String email = '';
  String institution = '';
  String address = '';
  String country = '';

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }
}
