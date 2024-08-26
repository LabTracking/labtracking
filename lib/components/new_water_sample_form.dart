import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewWaterSampleForm extends StatefulWidget {
  String? storageCondition;
  String co2 = '';
  String ch4 = '';
  String no2 = '';

  String previousSample = '';

  final String labId;
  final bool transformation;

  NewWaterSampleForm(this.labId, this.transformation);

  @override
  State<NewWaterSampleForm> createState() => _NewWaterSampleFormState();
}

class _NewWaterSampleFormState extends State<NewWaterSampleForm> {
  //final storageConditionController = TextEditingController();
  final previousSampleController = TextEditingController();

  Stream<QuerySnapshot>? _samplesStream;
  String? storageConditionController;

  final List<String> _options = [
    'Raw',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _samplesStream = FirebaseFirestore.instance
        .collection('samples')
        .where('labId', isEqualTo: widget.labId)
        .snapshots();
  }

  void _updateEmailStream(String searchTerm) {
    setState(() {
      _samplesStream = FirebaseFirestore.instance
          .collection('samples')
          .where('sampleType', isEqualTo: 'water')
          //.where('id', isEqualTo: searchTerm + 'z')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.transformation == false
            ? const SizedBox(height: 15)
            : const SizedBox(height: 0),
        DropdownButtonFormField<String>(
          key: const ValueKey('storageCondition'),
          decoration: InputDecoration(
            hintText: 'Storage condition',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              //borderSide: BorderSide.none, // Remove border
            ),
            filled: true,
            fillColor: Colors.black12, // Fill color set to transparent
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          value: storageConditionController,
          items: _options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              storageConditionController = value;
              widget.storageCondition = storageConditionController;
            });
          },
        ),
      ],
    );
  }
}
