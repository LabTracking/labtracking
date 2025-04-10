import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'package:labtracking/models/new_researcher_form_data.dart';
import 'package:labtracking/screens/new_sample_type_screen.dart';
import 'package:provider/provider.dart';
import 'models/point.dart';
import 'package:labtracking/screens/signup_or_app_screen.dart';
import 'package:labtracking/utils/routes.dart';
import 'screens/login_screen.dart';

import 'package:labtracking/utils/eula.dart';
import 'screens/eula_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkEULAStatus();
  }

  Future<void> _checkEULAStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final eulaAccepted = prefs.getBool('eulaAccepted') ?? false;

    if (!eulaAccepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const EULAScreen()),
        );
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Coords(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewResearcherFormData(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'LabTracking',
        home: _isLoading
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : const LoginScreen(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromARGB(255, 126, 217, 87),
              secondary: const Color.fromARGB(255, 92, 225, 230),
              background: Colors.white),
          canvasColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        routes: {
          AppRoutes.HOME: (ctx) => LoginScreen(),
          AppRoutes.SIGNUP_OR_APP: (ctx) => SignUpOrAppScreen(),
          AppRoutes.NEW_SAMPLE_TYPE: (ctx) => NewSampleTypeScreen(),
        },
      ),
    );
  }
}
