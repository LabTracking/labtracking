import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/screens/sample_details_screen.dart';
import 'package:labtracking/services/sample_service.dart';

class TreeNode extends StatefulWidget {
  final Sample sample;
  final Function(Sample) onTap;
  final String? highlightId;
  final int level;
  final Map<String, dynamic> researcherData;
  final Sample mainSample;

  const TreeNode({
    Key? key,
    required this.sample,
    required this.onTap,
    required this.highlightId,
    required this.researcherData,
    required this.mainSample,
    this.level = 0,
  }) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final hasChildren =
        widget.sample.samples != null && widget.sample.samples!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(left: 24.0 * widget.level),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasChildren)
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, right: 8.0),
                    child: Icon(
                      _isExpanded ? Icons.remove : Icons.add,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                const SizedBox(width: 28),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTap(widget.sample),
                  child: Card(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(
                        width: 1,
                        color: widget.sample.id == widget.highlightId
                            ? Colors.red
                            : Colors.transparent,
                      ),
                    ),
                    color: widget.sample.exists!
                        ? const Color.fromARGB(255, 154, 241, 180)
                        : const Color.fromARGB(255, 205, 198, 198),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    widget.sample.exists!
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: widget.sample.exists!
                                        ? Colors.lightBlue
                                        : Colors.redAccent,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.sample.sampleName!.isNotEmpty
                                        ? widget.sample.sampleName!
                                        : "No name",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => SampleDetailsScreen(
                                        sample: widget.sample,
                                        researcherData: widget.researcherData,
                                        mainSample: widget.mainSample,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.info,
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.sample.researcherEmail!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.thermostat_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.sample.storageTemperature?.isNotEmpty ??
                                        false
                                    ? widget.sample.storageTemperature![0].keys
                                        .toList()[0]
                                    : "Unknown",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.pin_drop_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.sample.storageCondition?.isNotEmpty ??
                                        false
                                    ? widget.sample.storageCondition.toString()
                                    : "Unknown",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isExpanded && hasChildren)
            Column(
              children: widget.sample.samples!
                  .map((child) => TreeNode(
                        sample: child,
                        onTap: widget.onTap,
                        highlightId: widget.highlightId,
                        researcherData: widget.researcherData,
                        mainSample: widget.mainSample,
                        level: widget.level + 1,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class TrackScreen extends StatefulWidget {
  final Sample mainSample;
  final Sample sample;
  final Map<String, dynamic> researcherData;

  const TrackScreen({
    Key? key,
    required this.mainSample,
    required this.sample,
    required this.researcherData,
  }) : super(key: key);

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  late Sample _currentMainSample;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentMainSample = widget.mainSample;
    _fetchMainSample();
  }

  Future<void> _fetchMainSample() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('samples')
          .doc(widget.mainSample.id)
          .get();

      if (!snapshot.exists) {
        print("Main sample not found in Firestore");
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      NewSampleService service = NewSampleService();
      Sample fetchedSample = service.fromFirestore(snapshot, null);

      if (mounted) {
        setState(() {
          _currentMainSample = fetchedSample;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching main sample: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onNodeTap(Sample sample) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: (sample.exists!
                  ? const Color.fromARGB(255, 154, 241, 180)
                  : const Color.fromARGB(255, 205, 198, 198)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      sample.exists! ? Icons.check : Icons.cancel,
                      color: sample.exists!
                          ? Colors.lightBlue
                          : const Color.fromARGB(255, 243, 124, 115),
                    ),
                    Text(
                      " ${sample.sampleName! != "" ? sample.sampleName! : "No name"}",
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 17,
                    ),
                    Text(
                      " ${sample.researcherEmail!}",
                      style:
                          const TextStyle(color: Colors.blueGrey, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.air_outlined,
                      size: 17,
                    ),
                    Text(
                      sample.storageTemperature!.isNotEmpty
                          ? " ${sample.storageTemperature![0].keys.toList()[0].toString()}"
                          : " Condition",
                      style:
                          const TextStyle(color: Colors.blueGrey, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pin_drop_outlined,
                      size: 17,
                    ),
                    Text(
                      sample.storageCondition!.isNotEmpty
                          ? " ${sample.storageCondition.toString()}"
                          : " Storage Condition",
                      style:
                          const TextStyle(color: Colors.blueGrey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => SampleDetailsScreen(
                              sample: sample,
                              researcherData: widget.researcherData,
                              mainSample: widget.mainSample,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.info,
                        color: Color.fromARGB(255, 4, 110, 163),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LabTrackingBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: TreeNode(
                sample: _currentMainSample,
                onTap: _onNodeTap,
                highlightId: widget.sample.id,
                researcherData: widget.researcherData,
                mainSample: _currentMainSample,
                level: 0,
              ),
            ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_treeview/flutter_treeview.dart';
// import 'package:labtracking/components/lab_tracking_bar.dart';
// import 'package:labtracking/models/sample.dart';
// import 'package:labtracking/screens/sample_details_screen.dart';

// class TrackScreen extends StatefulWidget {
//   final Sample mainSample; // Main sample to build the tree
//   final Sample sample; // Sample to highlight
//   final Map<String, dynamic> researcherData;

//   const TrackScreen({
//     Key? key,
//     required this.mainSample,
//     required this.sample,
//     required this.researcherData,
//   }) : super(key: key);

//   @override
//   _TrackScreenState createState() => _TrackScreenState();
// }

// class _TrackScreenState extends State<TrackScreen> {
//   late TreeViewController _treeViewController;

//   @override
//   void initState() {
//     super.initState();
//     List<Node> nodes = _buildTreeNodes(widget.mainSample);
//     _treeViewController = TreeViewController(children: nodes);
//   }

//   // Build tree nodes recursively
//   List<Node> _buildTreeNodes(Sample sample) {
//     return [
//       Node(
//         label: sample.name!,
//         key: sample.id!,
//         data: sample,
//         expanded: true,
//         children: sample.samples!
//             .map((child) => _buildTreeNodes(child))
//             .expand((node) => node)
//             .toList(),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: LabTrackingBar(),
//       body: Stack(
//         children: [
//           TreeView(
//             controller: _treeViewController,
//             allowParentSelect: true,
//             supportParentDoubleTap: true,
//             onExpansionChanged: (key, expanded) {
//               setState(() {
//                 _treeViewController = _treeViewController.copyWith(
//                   children: _updateExpandedState(
//                       _treeViewController.children, key, expanded),
//                 );
//               });
//             },
//             nodeBuilder: (context, node) {
//               Sample sample = node.data;
//               return GestureDetector(
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => Center(
//                       child: SingleChildScrollView(
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * 0.8,
//                           padding: const EdgeInsets.all(16.0),
//                           decoration: BoxDecoration(
//                             color: (sample.exists!
//                                 ? const Color.fromARGB(255, 154, 241, 180)
//                                 : const Color.fromARGB(255, 205, 198, 198)),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     sample.exists! ? Icons.check : Icons.cancel,
//                                     color: sample.exists!
//                                         ? Colors.lightBlue
//                                         : const Color.fromARGB(
//                                             255, 243, 124, 115),
//                                   ),
//                                   Text(
//                                     " ${sample.sampleName! != "" ? sample.sampleName! : "No name"}",
//                                     style: const TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     Icons.email_outlined,
//                                     size: 17,
//                                   ),
//                                   Text(
//                                     " ${sample.researcherEmail!}",
//                                     style:
//                                         const TextStyle(color: Colors.blueGrey),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     Icons.air_outlined,
//                                     size: 17,
//                                   ),
//                                   Text(
//                                     sample.storageTemperature!.isNotEmpty
//                                         ? " ${sample.storageTemperature![0].keys.toList()[0].toString()}"
//                                         : " Condition",
//                                     style:
//                                         const TextStyle(color: Colors.blueGrey),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     Icons.pin_drop_outlined,
//                                     size: 17,
//                                   ),
//                                   Text(
//                                     sample.storageCondition!.isNotEmpty
//                                         ? " ${sample.storageCondition.toString()}"
//                                         : " Storage Condition",
//                                     style:
//                                         const TextStyle(color: Colors.blueGrey),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {
//                                       // Navigator.of(context).pushNamed(
//                                       //   AppRoutes.SAMPLE_DETAILS,
//                                       //   arguments: sample,
//                                       // );
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                           builder: (ctx) => SampleDetailsScreen(
//                                             sample: sample,
//                                             researcherData:
//                                                 widget.researcherData,
//                                             mainSample: widget.mainSample,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     icon: const Icon(
//                                       Icons.info,
//                                       color: Color.fromARGB(255, 4, 110, 163),
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     icon: const Icon(
//                                       Icons.close,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   shape: BeveledRectangleBorder(
//                     borderRadius: BorderRadius.circular(2),
//                     side: BorderSide(
//                       width: 0.5,
//                       color: sample.id == widget.sample.id
//                           ? Colors
//                               .red // Highlight parent sample with red border
//                           : Colors.transparent,
//                     ),
//                   ),
//                   color: sample.exists!
//                       ? const Color.fromARGB(255, 154, 241,
//                           180) // Light green for existing samples
//                       : const Color.fromARGB(
//                           255, 205, 198, 198), // Grey for non-existing samples
//                   elevation: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(7.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   sample.exists!
//                                       ? Icons.check_circle
//                                       : Icons.cancel,
//                                   color: sample.exists!
//                                       ? Colors
//                                           .lightBlue // Icon color for existing
//                                       : Colors
//                                           .redAccent, // Icon color for non-existing
//                                   size: 18,
//                                 ),
//                                 const SizedBox(width: 5),
//                                 Text(
//                                   sample.sampleName!.isNotEmpty
//                                       ? sample.sampleName!
//                                       : "No name",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (ctx) => SampleDetailsScreen(
//                                       sample: sample,
//                                       researcherData: widget.researcherData,
//                                       mainSample: widget.mainSample,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               icon: const Icon(
//                                 Icons.info,
//                                 color: Colors.blueAccent,
//                                 size: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.email_outlined,
//                               size: 16,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               sample.researcherEmail!,
//                               style: const TextStyle(
//                                   fontSize: 12, color: Colors.blueGrey),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.thermostat_outlined,
//                               size: 16,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               sample.storageTemperature?.isNotEmpty ?? false
//                                   ? sample.storageTemperature![0].keys
//                                       .toList()[0]
//                                   : "Unknown",
//                               style: const TextStyle(
//                                   fontSize: 12, color: Colors.blueGrey),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.pin_drop_outlined,
//                               size: 16,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               sample.storageCondition?.isNotEmpty ?? false
//                                   ? sample.storageCondition.toString()
//                                   : "Unknown",
//                               style: const TextStyle(
//                                   fontSize: 12, color: Colors.blueGrey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//             theme: const TreeViewTheme(
//               expanderTheme: ExpanderThemeData(
//                 type: ExpanderType.chevron,
//                 position: ExpanderPosition.start,
//                 size: 30,
//               ),
//               labelStyle: TextStyle(fontSize: 16, color: Colors.black),
//               parentLabelStyle:
//                   TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Node> _updateExpandedState(List<Node> nodes, String key, bool expanded) {
//     return nodes.map((node) {
//       if (node.key == key) {
//         return node.copyWith(expanded: expanded);
//       } else if (node.children.isNotEmpty) {
//         return node.copyWith(
//           children: _updateExpandedState(node.children, key, expanded),
//         );
//       }
//       return node;
//     }).toList();
//   }
// }
