import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewWaterSampleForm extends StatefulWidget {
  String waterType = '';
  String co2 = '';
  String ch4 = '';
  String no2 = '';

  String previousSample = '';

  final String labId;

  NewWaterSampleForm(this.labId);

  @override
  State<NewWaterSampleForm> createState() => _NewWaterSampleFormState();
}

class _NewWaterSampleFormState extends State<NewWaterSampleForm> {
  final waterTypeController = TextEditingController();
  final co2Controller = TextEditingController();
  final ch4Controller = TextEditingController();
  final no2Controller = TextEditingController();

  final previousSampleController = TextEditingController();

  Stream<QuerySnapshot>? _samplesStream;

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
        TextFormField(
          key: const ValueKey('waterType'),
          controller: waterTypeController,
          onChanged: (type) {
            setState(() => waterTypeController.text = type);

            widget.waterType = waterTypeController.text;
            print(widget.waterType);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Water type',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('co2'),
          controller: co2Controller,
          onChanged: (type) {
            setState(() => co2Controller.text = type);

            widget.co2 = co2Controller.text;
            print(widget.co2);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'CO2',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('ch4'),
          controller: ch4Controller,
          onChanged: (type) {
            setState(() => ch4Controller.text = type);

            widget.ch4 = ch4Controller.text;
            print(widget.ch4);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'CH4',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('no2'),
          controller: no2Controller,
          onChanged: (type) {
            setState(() => no2Controller.text = type);

            widget.no2 = no2Controller.text;
            print(widget.no2);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'NO2',
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _samplesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            List<String> samples = snapshot.data!.docs
                .where((element) => element['sampleType'] == 'water')
                .map((doc) => doc.id.toString())
                .toList();
            return DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                showSelectedItems: true,
                //disabledItemFn: (String s) => s.startsWith('I'),
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Transformation of any previous sample?",
                  //hintText: "country in menu mode",
                ),
              ),
              items: samples,

              //label: "Select Email",
              //hint: "Select Email",
              onChanged: (String? value) {
                // Do something with the selected email
                setState(() {
                  previousSampleController.text = value!;
                  widget.previousSample = previousSampleController.text;
                });
              },
            );
          },
        ),
      ],
    );
  }
}
