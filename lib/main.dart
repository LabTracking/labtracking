import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:labtracking/utils/routes.dart';

import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
