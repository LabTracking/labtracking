import 'package:flutter/material.dart';
import 'package:labtracking/components/sample_item.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/services/sample_service.dart';

class SamplesList extends StatelessWidget {
  final String labId;
  final Map<String, dynamic> researcherData;
  const SamplesList({
    required this.researcherData,
    required this.labId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final currentUser = AuthService().currentUser;
    return Expanded(
      child: StreamBuilder<List<Sample>>(
        stream: NewSampleService().samplesStream(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData
              //     || snapshot.data!.where(
              //   (element) => element.labId == labId && element.checkin == true
              // ).toList().isEmpty
              ) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload,
                  color: Colors.green,
                ),
                Text(
                  'Do your first sample check-in',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ));
          } else {
            List<Sample> samples = snapshot.data!
                .where((element) => element.labId == labId)
                .toList();

            if (samples.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload,
                      color: Colors.green,
                    ),
                    Text(
                      'Do your first sample check-in',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              //samples.sort((b, a) => b['sampleType'].compareTo(a['sampleType']));
              print(samples.length);
              for (var sample in samples) {
                print(
                    "Sample name: ${sample.name}\n${sample.researcherEmail}\n${sample.sampleType}");
              }
              return ListView.builder(
                //reverse: true,
                itemCount: samples.length,
                // itemBuilder: (ctx, i) => SampleItem(
                //   type: samples[i]['sampleType'],
                //   user: samples[i]['researcherEmail'],
                //   details: samples[i],
                //   id: samples[i]["id"],
                //   date: samples[i]['date'].toString().isEmpty
                //       ? DateTime.now().toString()
                //       : samples[i]['date'].toString(),
                itemBuilder: (ctx, i) => SampleItem(
                  researcherData: researcherData, sample: samples[i],
                  mainSample: samples[i],
                  // type: samples[i].sampleType!,
                  // user: samples[i].researcherEmail!,
                  // details: {}, //samples[i],
                  // id: samples[i].id,
                  // date: samples[i].date.toString().isEmpty
                  //     ? DateTime.now().toString()
                  //     : samples[i].date.toString(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
