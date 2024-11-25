import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/components/sample_transformation_form.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/screens/sample_transformation_screen.dart';
import 'package:labtracking/utils/location_utill.dart';
import '../screens/track_screen.dart';
import '../utils/capitalize.dart';
import '../utils/show_sample_details_alert.dart';

class SampleDetailsScreen extends StatefulWidget {
  //final String labId
  final Map<String, dynamic> researcherData;
  final Sample sample;

  const SampleDetailsScreen({
    required this.researcherData,
    required this.sample,
  });
  //const SampleDetailsScreen({required this.labId, super.key});
  @override
  State<SampleDetailsScreen> createState() => _SampleDetailsScreenState();
}

class _SampleDetailsScreenState extends State<SampleDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  Future<String> getLabName(String documentId) async {
    try {
      // Get the document from the labs collection
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('labs')
          .doc(documentId)
          .get();

      // Check if the document exists and return the labName
      if (doc.exists) {
        String labName = doc.get('labName');
        return labName;
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error getting labName: $e');
    }
  }

  String? labName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the sample object from the ModalRoute
    final sample = ModalRoute.of(context)?.settings.arguments as Sample?;

    // Fetch the labName if the sample is available
    if (sample != null) {
      getLabName(sample.labId!).then((name) {
        setState(() {
          labName = name; // Save the labName in the state variable
        });
      }).catchError((error) {
        print('Error: $error');
        // Handle error appropriately here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final sample = (ModalRoute.of(context)?.settings.arguments as Sample);
    final sample = widget.sample;
    final String imageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: sample.latitude,
      longitude: sample.longitude,
    );

    Widget sampleLocation = Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
          ),
        ),
      ),
    );

    // sampleDetails.forEach((key, value) {
    //   if (value != "") {
    //     details.add(
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(key),
    //           Text(": "),
    //           Text(value.toString()),
    //         ],
    //       ),
    //     );
    //   }
    // });
    //print("OK $details");

    Future getResearcher(String researcherId, String key) async {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('researchers').get();
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        if (snapshot.id == researcherId) {
          print(snapshot.get(key).toString());
          return snapshot.get(key).toString();
        }
      }
    }

    getLab(String labId) async {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('labs').get();
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        if (snapshot.id == labId) {
          return snapshot.get(labId).data()["labName"];
        }
      }
    }

    void _openSampleTransformationScreen() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SampleTransformationScreen(
            sample: sample,
            researcherData: widget.researcherData,
            //labId: sampleDetails["labId"],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: LabTrackingBar(),
      body: Container(
        color: Colors.white, // Background color
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
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
                    Center(
                      child: Text(
                        sample.sampleName != ""
                            ? " ${sample.sampleName!}"
                            : " No name",
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Text(
                    //   "Sample name",
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 14.0,
                    //       color: Colors.black),
                    // )
                  ],
                ),
                const SizedBox(height: 1.0),
                const SizedBox(height: 0),
                sampleLocation,
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
                const SizedBox(height: 0),
                // ListTile(
                //   title: const Text(
                //     'Researcher Email',
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: Text(
                //     sample.researcherEmail!,
                //     style: const TextStyle(color: Colors.grey),
                //   ),
                //   leading: const Icon(
                //     Icons.email_outlined,
                //     color: Color.fromARGB(255, 126, 217, 87),
                //   ),
                // ),
                const SizedBox(height: 0),
                ListTile(
                  title: const Text(
                    'Laboratory',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    capitalize(labName ?? ""),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.business_outlined,
                    color: Color.fromARGB(255, 126, 217, 87),
                  ),
                ),
                const SizedBox(height: 0),
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
                const SizedBox(height: 0),
                ListTile(
                  title: sample.exists! == true
                      ? const Text(
                          'Available',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : const Text(
                          'Not available',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                  // subtitle: Text(
                  //   sample.exists!.toString(),
                  //   style: const TextStyle(color: Colors.grey),
                  // ),
                  leading: sample.exists! == true
                      ? const Icon(
                          Icons.event_available,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: sample.samples!.isNotEmpty
                              ? () {
                                  print(sample.samples);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => TrackScreen(
                                        sample: sample,
                                        researcherData: widget.researcherData,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue),
                          child: const Text(
                            "Track",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
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
