import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/screens/sample_transformation_screen.dart';
import '../screens/track_screen.dart';
import '../utils/capitalize.dart';
import '../utils/show_sample_details_alert.dart';
import '../utils/location_utill.dart';

class SampleDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> researcherData;
  final Sample sample;
  final Sample mainSample;

  const SampleDetailsScreen({
    required this.researcherData,
    required this.sample,
    required this.mainSample,
  });

  @override
  State<SampleDetailsScreen> createState() => _SampleDetailsScreenState();
}

class _SampleDetailsScreenState extends State<SampleDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? labName;

  Future<void> fetchLabName(String labId) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('labs').doc(labId).get();

      if (doc.exists) {
        setState(() {
          labName = doc.get('labName');
        });
      } else {
        throw Exception('Lab document does not exist');
      }
    } catch (error) {
      print('Error fetching lab name: $error');
      setState(() {
        labName = 'Unknown Lab';
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchLabName(widget.sample.labId!);
  }

  void _openSampleTransformationScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SampleTransformationScreen(
          sample: widget.sample,
          researcherData: widget.researcherData,
          mainSample: widget.mainSample,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sample = widget.sample;

    final String imageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: sample.latitude,
      longitude: sample.longitude,
    );

    return Scaffold(
      appBar: LabTrackingBar(
        researcherData: widget.researcherData,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 26.0,
                      color: Colors.blue,
                    ),
                    Text(
                      sample.sampleName!.isNotEmpty
                          ? " ${sample.sampleName}"
                          : " No name",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InteractiveViewer(
                    child: Image.network(imageUrl),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text(
                    'Added by',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    sample.researcherEmail!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.person_outline,
                    color: Color.fromARGB(255, 126, 217, 87),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Laboratory',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    labName != null ? capitalize(labName!) : 'Loading...',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.business_outlined,
                    color: Color.fromARGB(255, 126, 217, 87),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Sample Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    capitalize(sample.sampleType!),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.category_outlined,
                    color: Color.fromARGB(255, 126, 217, 87),
                  ),
                ),
                ListTile(
                  title: sample.exists!
                      ? const Text(
                          'Available',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : const Text(
                          'Not available',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                  leading: sample.exists!
                      ? const Icon(
                          Icons.event_available,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: sample.exists == true
                              ? widget.researcherData["type"] == "observer"
                                  ? null
                                  : _openSampleTransformationScreen
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          child: const Text(
                            "Split or change",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          //onPressed: sample.samples!.isNotEmpty
                          //?
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => TrackScreen(
                                  sample: sample,
                                  researcherData: widget.researcherData,
                                  mainSample: widget.mainSample,
                                ),
                              ),
                            );
                          },
                          //: null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue),
                          child: const Text(
                            "Track",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => showSampleDetailsDialog(
                            context,
                            sample,
                            widget.researcherData,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text(
                            "Details",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
