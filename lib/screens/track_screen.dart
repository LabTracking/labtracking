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
        padding: EdgeInsets.only(left: 30.0 * level),
        // child: Text(sample.sampleType!,
        //     style: TextStyle(fontSize: 16 + (level * 2).toDouble())),
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 5),
          child: Card(
            color: const Color.fromARGB(255, 216, 219, 221),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.science,
                          color: Colors.lightBlue,
                        ),
                        Text(
                          sample.name!,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      sample.date!,
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        sample.researchEmail!,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_tree,
                      color: Colors.blue,
                    ),
                    Text(
                      " Track tree",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              buildSampleTree(widget.sample),
            ],
          ),
        ),
      ),
    );
  }
}
