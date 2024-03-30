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
            List<Sample> sampleChain = snapshot.data!.toList();
            return ListView.builder(
              itemCount: sampleChain.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sampleChain[index].name),
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
    await fetchSample(sampleId).then((sample) {
      sampleChain.add(sample);
      if (sample.previousSampleId.isNotEmpty) {
        return fetchSampleChain(sample.previousSampleId).then((chain) {
          sampleChain.addAll(chain);
        });
      }
    });
    return sampleChain;
  }
}

class Sample {
  String id;
  String name;
  String previousSampleId;

  Sample(
      {required this.id, required this.name, required this.previousSampleId});
}

Future<Sample> fetchSample(String sampleId) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('samples')
      .doc(sampleId)
      .get();

  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // Construct the sample object based on the available fields
    Sample sample = Sample(
      id: snapshot.id,
      name: data.containsKey('name') ? data['name'] : '',
      previousSampleId:
          data.containsKey('previousSample') ? data['previousSample'] : '',
      // Add other fields similarly based on the actual field names
    );
    return sample;
  } else {
    throw Exception('Sample not found');
  }
}
