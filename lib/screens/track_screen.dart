// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:labtracking/components/lab_tracking_bar.dart';
// import 'package:labtracking/models/sample.dart';

// import 'package:labtracking/utils/routes.dart';
// import '../services/auth_service.dart';
// import 'package:labtracking/components/about_window.dart';
// import "../screens/sample_details.screen.dart";
// import '../utils/arrow_painter.dart';

// class TrackScreen extends StatefulWidget {
//   final Sample sample;
//   const TrackScreen({required this.sample});

//   @override
//   State<TrackScreen> createState() => _TrackScreenState();
// }

// class _TrackScreenState extends State<TrackScreen> {
//   Widget buildSampleTree(Sample sample, [int level = 0]) {
//     List<Widget> widgetList = [];

//     // Add the current sample card
//     widgetList.add(
//       Padding(
//         padding: EdgeInsets.only(left: 30.0 * level),
//         child: InkWell(
//           onTap: () {
//             Navigator.of(context)
//                 .pushNamed(AppRoutes.SAMPLE_DETAILS, arguments: sample);
//           },
//           child: Card(
//             color: sample.exists == true
//                 ? Color.fromARGB(255, 154, 241, 180)
//                 : Color.fromARGB(255, 236, 173, 173),
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: SizedBox(
//                 width: 150,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           sample.exists == true ? Icons.check : Icons.cancel,
//                           color: sample.exists == true
//                               ? Colors.lightBlue
//                               : Colors.red,
//                         ),
//                         Text(
//                           " ${sample.name!}",
//                           style: const TextStyle(
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       sample.date!,
//                       style: const TextStyle(color: Colors.blueGrey),
//                     ),
//                     FittedBox(
//                       fit: BoxFit.fitWidth,
//                       child: Text(
//                         sample.researcherEmail!,
//                         style: const TextStyle(color: Colors.blueGrey),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     // Add child samples and the connecting lines
//     if (sample.samples!.isNotEmpty) {
//       for (var i = 0; i < sample.samples!.length; i++) {
//         var element = sample.samples![i];

//         // Add the connecting lines
//         widgetList.add(
//           Stack(
//             children: [
//               Positioned(
//                 left: 30.0 * level +
//                     55, // Adjust horizontal alignment for vertical line
//                 top: -2, // Adjust vertical position for vertical line
//                 child: CustomPaint(
//                   painter: ArrowPainter(
//                     start: Offset(-30,
//                         -5.0 * level), // Starting point for the vertical line
//                     end: Offset(0, 50.0), // Length of the vertical line
//                     horizontalOffset: 30.0 *
//                         (level + 2), // Horizontal line extension to child
//                   ),
//                   size: const Size(
//                       50, 40), // Adjust size to cover the drawing area
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                     left: 5.0 * (level + 1),
//                     top: 5), // Align the child card under the lines
//                 child: buildSampleTree(element, level + 1),
//               ),
//             ],
//           ),
//         );
//       }
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: widgetList,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: LabTrackingBar(),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               const Padding(
//                 padding: EdgeInsets.only(left: 8.0),
//                 child: Row(
//                   //mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.account_tree,
//                       color: Colors.blue,
//                     ),
//                     Text(
//                       " Tracking tree",
//                       style: TextStyle(fontSize: 20, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               buildSampleTree(widget.sample),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/utils/routes.dart';

class TrackScreen extends StatefulWidget {
  final Sample sample;

  const TrackScreen({Key? key, required this.sample}) : super(key: key);

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  late TreeViewController _treeViewController;

  @override
  void initState() {
    super.initState();
    _treeViewController = TreeViewController(
      children: _buildTreeNodes(widget.sample),
    );
  }

  // Recursive function to build the tree nodes from your sample structure
  List<Node> _buildTreeNodes(Sample sample) {
    return [
      Node(
        label: sample.name!,
        key: sample.id!,
        data: sample,
        children: sample.samples!
            .map((child) => _buildTreeNodes(child))
            .expand((node) => node)
            .toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LabTrackingBar(),
      body: TreeView(
        controller: _treeViewController,
        allowParentSelect: true,
        supportParentDoubleTap: true,
        // onNodeTap: (key) {
        //   Node? tappedNode = _treeViewController.getNode(key);
        //   if (tappedNode != null) {
        //     Sample tappedSample = tappedNode.data;
        //     //   Navigator.of(context)
        //     //       .pushNamed(AppRoutes.SAMPLE_DETAILS, arguments: tappedSample);
        //   }
        // },
        nodeBuilder: (context, node) {
          // Customize the appearance of each node
          Sample sample = node.data;

          return Padding(
            padding: const EdgeInsets.only(
                top: 2), //, left: 5, right: 5, bottom: 5),
            child: Card(
              color: sample.exists!
                  ? const Color.fromARGB(255, 154, 241, 180)
                  : Color.fromARGB(255, 205, 198, 198),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                sample.exists! ? Icons.check : Icons.cancel,
                                color: sample.exists!
                                    ? Colors.lightBlue
                                    : Color.fromARGB(255, 243, 124, 115),
                              ),
                              Text(
                                " ${sample.name!} - ${sample.date}",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),

                          // Text(
                          //   sample.researcherEmail!,
                          //   style: const TextStyle(color: Colors.blueGrey),
                          // ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    AppRoutes.SAMPLE_DETAILS,
                                    arguments: sample);
                              },
                              icon: const Icon(
                                Icons.info,
                                color: Colors.blueGrey,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        theme: const TreeViewTheme(
          expanderTheme: ExpanderThemeData(
            type: ExpanderType.plusMinus, // Ensure the plus/minus icon is used
            modifier: ExpanderModifier.none,
            position: ExpanderPosition.start,
            color: Colors.blueGrey,
            size: 25,
          ),
          labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          parentLabelStyle:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(size: 30, color: Colors.blue),
        ),
      ),
    );
  }
}
