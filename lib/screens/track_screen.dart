import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackScreen extends StatelessWidget {
  final String sampleId;

  TrackScreen({required this.sampleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Chain'),
      ),
      body: FutureBuilder<List<Sample>>(
        future: fetchSampleChain(sampleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Sample> sampleChain = snapshot.data!;
            return ListView.builder(
              itemCount: sampleChain.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sampleChain[index].id),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Previous Sample: ${sampleChain[index].previousSampleId}'),
                      Text(
                          'Next Sample: ${sampleChain[index].nextSampleId ?? 'None'}'),
                    ],
                  ),
                  // You can add more details here if needed
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Sample>> fetchSampleChain(String sampleId) async {
    List<Sample> sampleChain = [];
    await fetchSample(sampleId).then((sample) async {
      // Follow nextSample pointers
      Sample? nextSample = sample;
      while (nextSample != null) {
        sampleChain.add(nextSample);
        if (nextSample.nextSampleId != null &&
            nextSample.nextSampleId!.isNotEmpty) {
          nextSample = await fetchSample(nextSample.nextSampleId!);
        } else {
          nextSample = null;
        }
      }

      // Backtrack using previousSample pointers
      Sample? previousSample = sample;
      while (previousSample != null &&
          previousSample.previousSampleId.isNotEmpty) {
        previousSample = await fetchSample(previousSample.previousSampleId);
        if (previousSample != null) {
          sampleChain.insert(0, previousSample);
        }
      }
    });
    return sampleChain;
  }
}

class Sample {
  String id;
  String previousSampleId;
  String? nextSampleId;

  Sample({required this.id, required this.previousSampleId, this.nextSampleId});
}

Future<Sample> fetchSample(String sampleId) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('samples')
      .doc(sampleId)
      .get();

  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data()!;
    String previousSampleId = data.containsKey('previousSample')
        ? data['previousSample'] as String
        : '';
    String? nextSampleId =
        data.containsKey('nextSample') ? data['nextSample'] as String : null;
    Sample sample = Sample(
      id: sampleId,
      previousSampleId: previousSampleId,
      nextSampleId: nextSampleId,
    );
    return sample;
  } else {
    throw Exception('Sample not found');
  }
}
