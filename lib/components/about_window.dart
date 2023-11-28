import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
      applicationLegalese: "© 2023 LabTracking.\nAll rights reserved.",
    );
  }
}
