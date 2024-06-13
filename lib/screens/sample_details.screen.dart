import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/about_window.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/components/sample_item.dart';
import 'package:labtracking/components/sample_transformation_form.dart';
import 'package:labtracking/components/samples_list.dart';
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
    final sampleDetails = (ModalRoute.of(context)?.settings.arguments as Map);

    final String imageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: sampleDetails["latitude"],
      longitude: sampleDetails["longitude"],
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
    print(sampleDetails);

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
      // Navigator.of(context).pushNamed(AppRoutes.SAMPLES, arguments: {
      //   'user': user,
      //   'auth': _auth,
      //   'google': _googleSignIn,
      //   'labName': labName,
      //   'labId': id,
      // });
      if (sampleDetails['nextSample'] == "") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => SampleTransformationScreen(
              sampleDetails: sampleDetails,
              labId: sampleDetails["labId"],
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('You have already derived a sample.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 32.0,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 3.0),
                    Text(
                      "Sample ID",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(height: 5.0),
                Center(
                  child: Text(
                    sampleDetails['id'],
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 0),
                sampleLocation,
                ListTile(
                  title: const Text(
                    'Researcher ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    sampleDetails["researcherId"],
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
                    sampleDetails['researcherEmail'],
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
                    sampleDetails['labId'],
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
                    sampleDetails['sampleType'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: const Icon(
                    Icons.category_outlined,
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
                          onPressed: _openSampleTransformationScreen,
                          child: Text(
                            "Transform",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 126, 217, 87),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: sampleDetails["nextSample"] == "" &&
                                  sampleDetails["previousSample"] == ""
                              ? null
                              : () {
                                  if (sampleDetails["nextSample"] != "" ||
                                      sampleDetails["previousSample"] != "") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TrackScreen(
                                          sampleId: sampleDetails['id'],
                                        ),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('No Sample Chain'),
                                        content: const Text(
                                            'This sample is not part of a track chain.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            "Track",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue),
                        ),
                        SizedBox(
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
