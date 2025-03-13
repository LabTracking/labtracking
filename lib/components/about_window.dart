import 'package:flutter/material.dart';

class AboutWindow {
  static Future<void> aboutDialog(BuildContext context) async {
    showAboutDialog(
      context: context,
      applicationName: "LabTracking",
      applicationIcon: SizedBox(
        height: 100,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
      ),
      applicationLegalese: "© 2025 LabTracking.\nAll rights reserved.",
    );
  }
}
