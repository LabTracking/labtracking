import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewWaterSampleForm extends StatefulWidget {
  String? storageCondition;
  final String labId;
  final bool transformation;

  NewWaterSampleForm(this.labId, this.transformation, {this.storageCondition});

  @override
  State<NewWaterSampleForm> createState() => _NewWaterSampleFormState();
}

class _NewWaterSampleFormState extends State<NewWaterSampleForm> {
  String? storageConditionController;

  final List<String> _options = [
    'Raw',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Carregar valor inicial do storageCondition
    storageConditionController = widget.storageCondition ?? _options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          key: const ValueKey('storageCondition'),
          decoration: InputDecoration(
            hintText: 'Storage condition',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: Colors.black12,
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
