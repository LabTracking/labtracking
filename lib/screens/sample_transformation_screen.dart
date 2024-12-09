import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/components/sample_transformation_form.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/utils/location_utill.dart';

class SampleTransformationScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //final String labId;
  //final Map sampleDetails;
  final Sample sample;
  final Map<String, dynamic> researcherData;
  final Sample mainSample;

  //SampleTransformationScreen(
  //  {required this.labId, required this.sampleDetails, super.key});
  SampleTransformationScreen({
    required this.sample,
    required this.researcherData,
    required this.mainSample,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: sample.latitude, longitude: sample.longitude);

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
    return Scaffold(
      appBar: LabTrackingBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 26.0,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 3.0),
                  Text(
                    "Derived from",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 1.0),
              Center(
                child: Text(
                  sample.sampleName! != "" ? sample.sampleName! : "No name",
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 0),
              sampleLocation,
              SampleTransformationForm(
                // researcherId: _auth.currentUser!.uid,
                // researcherEmail: _auth.currentUser!.email!,
                // labId: labId,
                // lat: sampleDetails["latitude"],
                // long: sampleDetails["longitude"],
                // sampleType: sampleDetails["sampleType"],
                // previousSample: sampleDetails["id"],
                // ecosystem: sampleDetails["ecosystem"],
                sample: sample,
                researcherData: researcherData,
                mainSample: mainSample,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
