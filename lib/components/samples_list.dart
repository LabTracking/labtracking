import 'package:flutter/material.dart';
import 'package:labtracking/components/sample_item.dart';
import 'package:labtracking/services/new_sample_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class SamplesList extends StatelessWidget {
  const SamplesList({super.key});

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
            List samples = snapshot.data!.toList();
            return ListView.builder(
                //reverse: true,
                itemCount: samples.length,
                itemBuilder: (ctx, i) =>
                    SampleItem(type: samples[i]['sampleType']));
          }
        },
      ),
    );
  }
}
