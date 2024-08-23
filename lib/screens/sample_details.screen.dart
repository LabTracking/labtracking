import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/about_window.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/components/sample_item.dart';
import 'package:labtracking/components/sample_transformation_form.dart';

import 'package:labtracking/components/samples_list.dart';

import 'package:labtracking/models/sample.dart';

import 'package:labtracking/screens/login_screen.dart';
import 'package:labtracking/screens/new_sample_screen.dart';
import 'package:labtracking/screens/new_sample_type_screen.dart';
import 'package:labtracking/screens/sample_transformation_screen.dart';
import 'package:labtracking/utils/location_utill.dart';
import 'package:labtracking/utils/routes.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';

import '../screens/track_screen.dart';

class SampleDetailsScreen extends StatefulWidget {
  //final String labId;
  //const SampleDetailsScreen({required this.labId, super.key});

  @override
  State<SampleDetailsScreen> createState() => _SampleDetailsScreenState();
}

class _SampleDetailsScreenState extends State<SampleDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    //final sampleDetails = (ModalRoute.of(context)?.settings.arguments as Map);
    final sample = (ModalRoute.of(context)?.settings.arguments as Sample);

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

    void _openSampleTransformationScreen() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SampleTransformationScreen(
            sample: sample,
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
                            : " Whithout name",
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
                    'Researcher ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    sample.researcherId!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.person_outline,
                    color: Color.fromARGB(255, 126, 217, 87),
                  ),
                ),
                const SizedBox(height: 0),
                ListTile(
                  title: const Text(
                    'Researcher Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    sample.researcherEmail!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.email_outlined,
                    color: Color.fromARGB(255, 126, 217, 87),
                  ),
                ),
                const SizedBox(height: 0),
                ListTile(
                  title: const Text(
                    'Lab ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    sample.labId!,
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
                    sample.sampleType!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.category_outlined,
                    color: Color.fromARGB(255, 126, 217, 87),
                  ),
                ),
                const SizedBox(height: 0),
                ListTile(
                  title: const Text(
                    'Available',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    sample.exists!.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.event_available,
                    color: Color.fromARGB(255, 126, 217, 87),
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
                              ? _openSampleTransformationScreen
                              : null,
                          child: Text(
                            "Split or change",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
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
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Text(
                            "Track",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () => {print("OK")},
                          child: Text(
                            "Download",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
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
