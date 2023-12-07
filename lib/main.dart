import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:labtracking/models/new_researcher_form_data.dart';
import 'package:labtracking/screens/labs_screen.dart';
import 'package:labtracking/screens/new_sample_screen.dart';
import 'package:labtracking/screens/new_sample_type_screen.dart';
import 'package:provider/provider.dart';

import 'models/point.dart';

import 'package:labtracking/screens/samples_screen.dart';
import 'package:labtracking/screens/signup_or_app_screen.dart';

import 'firebase_options.dart';
import 'package:labtracking/utils/routes.dart';

import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 126, 217, 87),
            secondary: const Color.fromARGB(255, 92, 225, 230),
          ),
          canvasColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        routes: {
          AppRoutes.HOME: (ctx) => LoginScreen(),
          AppRoutes.SIGNUP_OR_APP: (ctx) => SignUpOrAppScreen(),
          //AppRoutes.SAMPLES: (ctx) => SamplesScreen(),
          AppRoutes.NEW_SAMPLE_TYPE: (ctx) => NewSampleTypeScreen(),
          //AppRoutes.NEW_SAMPLE: (ctx) => NewSampleScreen(),
          AppRoutes.LABS: (ctx) => LabsScreen()
        },
      ),
    );
  }
}
