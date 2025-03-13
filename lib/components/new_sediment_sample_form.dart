import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewSedimentSampleForm extends StatefulWidget {
  String? remineralization;
  String co2 = '';
  String ch4 = '';
  String no2 = '';
  String sand = '';
  String silt = '';
  String clay = '';
  String n = '';
  String delta13c = '';
  String delta15n = '';
  String density = '';

  String previousSample = '';

  final String labId;
  final bool transformation;

  String? storageCondition;

  NewSedimentSampleForm(this.labId, this.transformation,
      {this.storageCondition});

  @override
  State<NewSedimentSampleForm> createState() => _NewSedimentSampleFormState();
}

class _NewSedimentSampleFormState extends State<NewSedimentSampleForm> {
  //final remineralizationController = TextEditingController();
  // String? remineralizationController;
  // final co2Controller = TextEditingController();
  // final ch4Controller = TextEditingController();
  // final no2Controller = TextEditingController();
  // final sandController = TextEditingController();
  // final siltController = TextEditingController();
  // final clayController = TextEditingController();
  // final nController = TextEditingController();
  // final delta13cController = TextEditingController();
  // final delta15nController = TextEditingController();
  // final densityController = TextEditingController();

  final previousSampleController = TextEditingController();

  Stream<QuerySnapshot>? _samplesStream;
  String? storageConditionController;

  final List<String> _options = [
    'Freeze-dried',
    'Lab oven',
    'Macerated',
    'Raw',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    storageConditionController = widget.storageCondition;
    _samplesStream = FirebaseFirestore.instance
        .collection('samples')
        .where('labId', isEqualTo: widget.labId)
        .snapshots();
  }

  void _updateEmailStream(String searchTerm) {
    setState(() {
      _samplesStream = FirebaseFirestore.instance
          .collection('samples')
          .where('sampleType', isEqualTo: 'sediment')
          //.where('id', isEqualTo: searchTerm + 'z')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.transformation == false) const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          key: const ValueKey('storageCondition'),
          decoration: InputDecoration(
            hintText: 'Storage condition',
            labelText: 'Storage condition',
            floatingLabelBehavior: FloatingLabelBehavior.always,
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
            widget.storageCondition = storageConditionController;
          },
        ),
      ],
    );
  }
}
