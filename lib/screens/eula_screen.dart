import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labtracking/screens/signup_or_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labtracking/utils/eula.dart'; // Importe o texto do EULA

class EULAScreen extends StatelessWidget {
  const EULAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AlertDialog(
            title: const Text(
                'Termos de Uso do LabTracking/LabTacking Terms of Use'),
            content: Text(eula),
            actions: [
              TextButton(
                child: const Text('Recusar/Decline'),
                onPressed: () => _closeApp(context),
              ),
              ElevatedButton(
                child: const Text('Aceitar/Accept'),
                onPressed: () => _acceptEULA(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _acceptEULA(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('eulaAccepted', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpOrAppScreen()),
    );
  }

  void _closeApp(BuildContext context) {
    Navigator.of(context).pop();
    SystemNavigator.pop(); // Fecha o aplicativo
  }
}
