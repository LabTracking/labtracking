import 'package:flutter/material.dart';
import 'package:labtracking/components/lab_item.dart';
import 'package:labtracking/components/sample_item.dart';
import 'package:labtracking/services/lab_service.dart';
import 'package:labtracking/services/new_sample_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class LabsList extends StatelessWidget {
  const LabsList({super.key});

  @override
  Widget build(BuildContext context) {
    //final currentUser = AuthService().currentUser;
    return Expanded(
      child: StreamBuilder<List>(
        stream: LabService().labsStream(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Add a new lab'));
          } else {
            List labs = snapshot.data!.toList();
            return ListView.builder(
              //reverse: true,
              itemCount: labs.length,
              itemBuilder: (ctx, i) => LabItem(
                id: labs[i]['id']!,
                labName: labs[i]['labName'],
                leaderName: labs[i]['leaderName'],
                members: labs[i]['members'] ?? [],
              ),
            );
          }
        },
      ),
    );
  }
}
