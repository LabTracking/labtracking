import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:labtracking/utils/routes.dart';
import '../services/auth_service.dart';
import 'package:labtracking/components/about_window.dart';

class TrackScreen extends StatelessWidget {
  final String sampleId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  TrackScreen({required this.sampleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // /automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/white_icon.png',
              fit: BoxFit.cover,
              height: 30,
            ),
            const Text(
              "LabTracking",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 126, 217, 87),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text(" My Account"),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text(" Settings"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text('Add new sample'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_suggest,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text(' Suggest new sample type'),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color.fromARGB(255, 126, 217, 87),
                        size: 23,
                      ),
                      Text(" About"),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 5,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 126, 217, 87),
                        size: 23,
                      ),
                      Text(" Logout"),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
                print("My account menu is selected.");
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                print("New Sample menu is selected.");
                Navigator.of(context).pushNamed(AppRoutes.NEW_SAMPLE);
              } else if (value == 3) {
                Navigator.of(context).pushNamed(AppRoutes.NEW_SAMPLE_TYPE);
              } else if (value == 4) {
                AboutWindow.aboutDialog(context);
                print("About is selected");
              } else if (value == 5) {
                await AuthService.logout(_auth, _googleSignIn);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false);

                print('deslogado');
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Sample>>(
        future: fetchSampleChain(sampleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Sample> sampleChain = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: sampleChain.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (index !=
                          0) // Draw arrows for all cards except the first one
                        SizedBox(
                          height: 40.0, // Adjust this value as needed
                          child: CustomPaint(
                            painter: ArrowPainter(
                              startX: 0, // X-coordinate of the start point
                              startY: 0.0, // Y-coordinate of the start point
                              endX: 0, // X-coordinate of the end point
                              endY: 50.0, // Y-coordinate of the end point
                            ),
                          ),
                        ),
                      Card(
                        color: Color.fromARGB(255, 138, 172, 195),
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Sample ${sampleChain[index].id}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Previous: ${sampleChain[index].previousSampleId == "" ? "None" : sampleChain[index].previousSampleId}',
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                    Text(
                                      'Next: ${sampleChain[index].nextSampleId == "" ? 'None' : sampleChain[index].nextSampleId}',
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                                // Add more details here if needed
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Sample>> fetchSampleChain(String sampleId) async {
    List<Sample> sampleChain = [];
    await fetchSample(sampleId).then((sample) async {
      // Follow nextSample pointers
      Sample? nextSample = sample;
      while (nextSample != null) {
        sampleChain.add(nextSample);
        if (nextSample.nextSampleId != null &&
            nextSample.nextSampleId!.isNotEmpty) {
          nextSample = await fetchSample(nextSample.nextSampleId!);
        } else {
          nextSample = null;
        }
      }

      // Backtrack using previousSample pointers
      Sample? previousSample = sample;
      while (previousSample != null &&
          previousSample.previousSampleId.isNotEmpty) {
        previousSample = await fetchSample(previousSample.previousSampleId);
        if (previousSample != null) {
          sampleChain.insert(0, previousSample);
        }
      }
    });
    return sampleChain;
  }
}

class ArrowPainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;

  ArrowPainter(
      {required this.startX,
      required this.startY,
      required this.endX,
      required this.endY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 233, 228, 228)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(startX, startY),
      Offset(endX, endY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Sample {
  String id;
  String previousSampleId;
  String? nextSampleId;

  Sample({required this.id, required this.previousSampleId, this.nextSampleId});
}

Future<Sample> fetchSample(String sampleId) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('samples')
      .doc(sampleId)
      .get();

  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data()!;
    String previousSampleId = data.containsKey('previousSample')
        ? data['previousSample'] as String
        : '';
    String? nextSampleId =
        data.containsKey('nextSample') ? data['nextSample'] as String : null;
    Sample sample = Sample(
      id: sampleId,
      previousSampleId: previousSampleId,
      nextSampleId: nextSampleId,
    );
    return sample;
  } else {
    throw Exception('Sample not found');
  }
}
