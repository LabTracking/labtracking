import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/screens/sample_details_screen.dart';
import 'package:labtracking/utils/routes.dart';

class TrackScreen extends StatefulWidget {
  final Sample sample;
  final Map<String, dynamic> researcherData;

  const TrackScreen({
    Key? key,
    required this.researcherData,
    required this.sample,
  }) : super(key: key);

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  late TreeViewController _treeViewController;

  @override
  void initState() {
    super.initState();
    List<Node> nodes = _buildTreeNodes(widget.sample);

    _treeViewController = TreeViewController(
      children: nodes,
    );
  }

  List<Node> _buildTreeNodes(Sample sample) {
    return [
      Node(
        label: sample.name!,
        key: sample.id!,
        data: sample,
        expanded: true, // Initially expand all nodes
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
      body: Stack(
        children: [
          TreeView(
            controller: _treeViewController,
            allowParentSelect: true,
            supportParentDoubleTap: true,
            onExpansionChanged: (key, expanded) {
              setState(() {
                _treeViewController = _treeViewController.copyWith(
                  children: _updateExpandedState(
                      _treeViewController.children, key, expanded),
                );
              });
            },
            nodeBuilder: (context, node) {
              Sample sample = node.data;
              return GestureDetector(
                onTap: () {
                  // When a card is tapped, navigate to a fullscreen overlay with the card’s details.
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
                                        : const Color.fromARGB(
                                            255, 243, 124, 115),
                                  ),
                                  Text(
                                    " ${sample.sampleName! != "" ? sample.sampleName! : "No name"}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 17,
                                  ),
                                  Text(
                                    " ${sample.researcherEmail!}",
                                    style:
                                        const TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.air_outlined,
                                    size: 17,
                                  ),
                                  Text(
                                    sample.storageTemperature!.isNotEmpty
                                        ? " ${sample.storageTemperature![0].keys.toList()[0].toString()}"
                                        : " Condition",
                                    style:
                                        const TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pin_drop_outlined,
                                    size: 17,
                                  ),
                                  Text(
                                    sample.storageCondition!.isNotEmpty
                                        ? " ${sample.storageCondition.toString()}"
                                        : " Storage Condition",
                                    style:
                                        const TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Navigator.of(context).pushNamed(
                                      //   AppRoutes.SAMPLE_DETAILS,
                                      //   arguments: sample,
                                      // );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => SampleDetailsScreen(
                                            sample: sample,
                                            researcherData:
                                                widget.researcherData,
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
                },
                child: Card(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(
                          width: 0.5,
                          color: sample.id == widget.sample.id
                              ? Colors.red
                              : Colors.transparent)),
                  color: (sample.exists!
                      ? const Color.fromARGB(255, 154, 241, 180)
                      : const Color.fromARGB(255, 205, 198, 198)),
                  elevation: 5,
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    sample.exists! ? Icons.check : Icons.cancel,
                                    color: sample.exists!
                                        ? Colors.lightBlue
                                        : const Color.fromARGB(
                                            255, 243, 124, 115),
                                  ),
                                  Text(
                                    " ${" ${sample.sampleName! != "" ? sample.sampleName! : "No name"}"}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 17,
                                  ),
                                  Text(
                                    " ${sample.researcherEmail!}",
                                    style:
                                        const TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.air_outlined,
                                    size: 17,
                                  ),
                                  Text(
                                    sample.storageTemperature!.isNotEmpty
                                        ? " ${sample.storageTemperature![0].keys.toList()[0].toString()}"
                                        : " Condition",
                                    style:
                                        const TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pin_drop_outlined,
                                    size: 17,
                                  ),
                                  Text(
                                    sample.storageCondition!.isNotEmpty
                                        ? " ${sample.storageCondition.toString()}"
                                        : " Storage Condition",
                                    style:
                                        const TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              // Navigator.of(context).pushNamed(
                              //   AppRoutes.SAMPLE_DETAILS,
                              //   arguments: sample,
                              // );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => SampleDetailsScreen(
                                    sample: sample,
                                    researcherData: widget.researcherData,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.info,
                              color: Color.fromARGB(255, 4, 110, 163),
                            ),
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
                type: ExpanderType.chevron,
                modifier: ExpanderModifier.none,
                position: ExpanderPosition.start,
                color: Colors.blueGrey,
                size: 35,
              ),
              labelStyle: TextStyle(fontSize: 16, color: Colors.black),
              parentLabelStyle:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(size: 30, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  List<Node> _updateExpandedState(List<Node> nodes, String key, bool expanded) {
    return nodes.map((node) {
      if (node.key == key) {
        return node.copyWith(expanded: expanded);
      } else if (node.children.isNotEmpty) {
        return node.copyWith(
          children: _updateExpandedState(node.children, key, expanded),
        );
      }
      return node;
    }).toList();
  }
}
