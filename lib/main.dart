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

  final prefs = await SharedPreferences.getInstance();
  bool eulaAccepted = prefs.getBool('eulaAccepted') ?? false;

  runApp(MyApp(eulaAccepted: eulaAccepted));
}

class MyApp extends StatelessWidget {
  final bool eulaAccepted;

  const MyApp({super.key, required this.eulaAccepted});

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
        debugShowCheckedModeBanner: false,
        title: 'LabTracking',
        //home: LoginScreen(),
        //home:
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
          //AppRoutes.SAMPLES: (ctx) => SamplesScreen(),
          AppRoutes.NEW_SAMPLE_TYPE: (ctx) => NewSampleTypeScreen(),
          //AppRoutes.NEW_SAMPLE: (ctx) => NewSampleScreen(),
          //AppRoutes.LABS: (ctx) => LabsScreen(),
          //AppRoutes.SAMPLE_DETAILS: (ctx) => SampleDetailsScreen()
        },
      ),
    );
  }
}
