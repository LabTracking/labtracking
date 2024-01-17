import 'package:flutter/material.dart';
import 'package:labtracking/components/sample_item.dart';
import 'package:labtracking/services/new_sample_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class SamplesList extends StatelessWidget {
  final String labId;
  const SamplesList({required this.labId, super.key});

  @override
  Widget build(BuildContext context) {
    //final currentUser = AuthService().currentUser;
    return Expanded(
      child: StreamBuilder<List>(
        stream: NewSampleService().samplesStream(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Add a new sample'));
          } else {
            List samples = snapshot.data!
                .where((element) => element['labId'] == labId)
                .toList();
            return ListView.builder(
              //reverse: true,
              itemCount: samples.length,
              itemBuilder: (ctx, i) => SampleItem(
                type: samples[i]['sampleType'],
                date: samples[i]['date'].toString().isEmpty
                    ? DateTime.now().toString()
                    : samples[i]['date'].toString(),
                user: samples[i]['researcherEmail'],
                details: samples[i],
              ),
            );
          }
        },
      ),
    );
  }
}
