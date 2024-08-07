import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/models/sample.dart';

import 'package:labtracking/utils/routes.dart';
import '../services/auth_service.dart';
import 'package:labtracking/components/about_window.dart';
import "../screens/sample_details.screen.dart";

class TrackScreen extends StatefulWidget {
  final Sample sample;
  const TrackScreen({required this.sample});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  Widget buildSampleTree(Sample sample, [int level = 0]) {
    // Create a list of widgets for the current sample and its children
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 16.0 * level),
        child: Text(sample.sampleType!,
            style: TextStyle(fontSize: 16 + (level * 2).toDouble())),
      ),
    ];

    // Add children widgets if samples is a List and contains Sample objects
    if (sample.samples is List) {
      for (var element in sample.samples!) {
        if (element is Sample) {
          widgetList.add(buildSampleTree(element, level + 1));
        }
      }
    }

    // Return a Column to display all widgets vertically
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LabTrackingBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_tree,
                color: Colors.blue,
              ),
              Text(
                "Track tree",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          buildSampleTree(widget.sample),
        ],
      ),
    );
  }
}

// class TrackScreen extends StatefulWidget {
//   final String sampleId;

//   TrackScreen({required this.sampleId});

//   @override
//   State<TrackScreen> createState() => _TrackScreenState();
// }

// class _TrackScreenState extends State<TrackScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: LabTrackingBar(),
//       body: FutureBuilder<List<Sample>>(
//         future: fetchSampleChain(widget.sampleId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             List<Sample> sampleChain = snapshot.data!;
//             return Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: ListView.builder(
//                 itemCount: sampleChain.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () async {
//                       // Navigate to the sample details screen
//                       DocumentSnapshot<Map<String, dynamic>> snapshot =
//                           await FirebaseFirestore.instance
//                               .collection('samples')
//                               .doc(sampleChain[index].id)
//                               .get();
//                       print(snapshot);
//                       Map<String, dynamic> data =
//                           snapshot.data() as Map<String, dynamic>;
//                       data["id"] = sampleChain[index].id;

//                       Navigator.of(context).pushNamed(
//                         AppRoutes.SAMPLE_DETAILS,
//                         arguments: data,
//                       );
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         if (index !=
//                             0) // Draw arrows for all cards except the first one
//                           SizedBox(
//                             height: 40.0, // Adjust this value as needed
//                             child: CustomPaint(
//                               painter: ArrowPainter(
//                                 startX: 0, // X-coordinate of the start point
//                                 startY: 0.0, // Y-coordinate of the start point
//                                 endX: 0, // X-coordinate of the end point
//                                 endY: 50.0, // Y-coordinate of the end point
//                               ),
//                             ),
//                           ),
//                         Card(
//                           color: Color.fromARGB(255, 161, 184, 199),
//                           elevation: 4.0,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: FittedBox(
//                               fit: BoxFit.scaleDown,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Sample ${sampleChain[index].id}',
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8.0),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'Previous: ${sampleChain[index].previousSampleId == "" ? "None" : sampleChain[index].previousSampleId}',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             color: Colors.white),
//                                       ),
//                                       Text(
//                                         'Next: ${sampleChain[index].nextSampleId == "" ? 'None' : sampleChain[index].nextSampleId}',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             color: Colors.white),
//                                       ),
//                                     ],
//                                   ),
//                                   // Add more details here if needed
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<List<Sample>> fetchSampleChain(String sampleId) async {
//     List<Sample> sampleChain = [];
//     await fetchSample(sampleId).then((sample) async {
//       // Follow nextSample pointers
//       Sample? nextSample = sample;
//       while (nextSample != null) {
//         sampleChain.add(nextSample);
//         if (nextSample.nextSampleId != null &&
//             nextSample.nextSampleId!.isNotEmpty) {
//           nextSample = await fetchSample(nextSample.nextSampleId!);
//         } else {
//           nextSample = null;
//         }
//       }

//       // Backtrack using previousSample pointers
//       Sample? previousSample = sample;
//       while (previousSample != null &&
//           previousSample.previousSampleId.isNotEmpty) {
//         previousSample = await fetchSample(previousSample.previousSampleId);
//         if (previousSample != null) {
//           sampleChain.insert(0, previousSample);
//         }
//       }
//     });
//     return sampleChain;
//   }
// }

// class ArrowPainter extends CustomPainter {
//   final double startX;
//   final double startY;
//   final double endX;
//   final double endY;

//   ArrowPainter(
//       {required this.startX,
//       required this.startY,
//       required this.endX,
//       required this.endY});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color.fromARGB(255, 233, 228, 228)
//       ..strokeWidth = 3
//       ..strokeCap = StrokeCap.round;

//     canvas.drawLine(
//       Offset(startX, startY),
//       Offset(endX, endY),
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class Sample {
//   String id;
//   String previousSampleId;
//   String? nextSampleId;

//   Sample({required this.id, required this.previousSampleId, this.nextSampleId});
// }

// Future<Sample> fetchSample(String sampleId) async {
//   DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//       .instance
//       .collection('samples')
//       .doc(sampleId)
//       .get();

//   if (snapshot.exists) {
//     Map<String, dynamic> data = snapshot.data()!;
//     String previousSampleId = data.containsKey('previousSample')
//         ? data['previousSample'] as String
//         : '';
//     String? nextSampleId =
//         data.containsKey('nextSample') ? data['nextSample'] as String : null;
//     Sample sample = Sample(
//       id: sampleId,
//       previousSampleId: previousSampleId,
//       nextSampleId: nextSampleId,
//     );
//     return sample;
//   } else {
//     throw Exception('Sample not found');
//   }
// }
