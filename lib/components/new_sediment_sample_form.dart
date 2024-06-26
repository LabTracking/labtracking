import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';

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

  NewSedimentSampleForm(
    this.labId,
    this.transformation,
  );

  @override
  State<NewSedimentSampleForm> createState() => _NewSedimentSampleFormState();
}

class _NewSedimentSampleFormState extends State<NewSedimentSampleForm> {
  //final remineralizationController = TextEditingController();
  String? remineralizationController;
  final co2Controller = TextEditingController();
  final ch4Controller = TextEditingController();
  final no2Controller = TextEditingController();
  final sandController = TextEditingController();
  final siltController = TextEditingController();
  final clayController = TextEditingController();
  final nController = TextEditingController();
  final delta13cController = TextEditingController();
  final delta15nController = TextEditingController();
  final densityController = TextEditingController();

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
          .where('sampleType', isEqualTo: 'sediment')
          //.where('id', isEqualTo: searchTerm + 'z')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextFormField(
        //   key: const ValueKey('remineralization'),
        //   controller: remineralizationController,
        //   onChanged: (type) {
        //     setState(() => remineralizationController.text = type);

        //     widget.remineralization = remineralizationController.text;
        //     print(widget.remineralization);
        //   },
        //   enabled: true,
        //   decoration: const InputDecoration(
        //     labelText: 'Remineralization',
        //   ),
        // ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Remineralization type',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(
                width: 15,
              ),
              DropdownButton<String>(
                value: remineralizationController,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.blue),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (newValue) {
                  setState(() {
                    remineralizationController = newValue;
                    widget.remineralization = remineralizationController;
                  });
                },
                items: <String>['Aerobic', 'Anaerobic']
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
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
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('sand'),
          controller: sandController,
          onChanged: (type) {
            setState(() => sandController.text = type);

            widget.sand = sandController.text;
            print(widget.sand);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Sand (%)',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('silt'),
          controller: siltController,
          onChanged: (type) {
            setState(() => siltController.text = type);

            widget.silt = siltController.text;
            print(widget.silt);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Silt (%)',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('clay'),
          controller: clayController,
          onChanged: (type) {
            setState(() => clayController.text = type);

            widget.clay = clayController.text;
            print(widget.clay);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Clay (%)',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('n'),
          controller: nController,
          onChanged: (type) {
            setState(() => nController.text = type);

            widget.n = nController.text;
            print(widget.n);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'N (%)',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('delta13c'),
          controller: delta13cController,
          onChanged: (type) {
            setState(() => delta13cController.text = type);

            widget.delta13c = delta13cController.text;
            print(widget.n);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Delta 13 C',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('delta15n'),
          controller: delta15nController,
          onChanged: (type) {
            setState(() => delta15nController.text = type);

            widget.delta15n = delta15nController.text;
            print(widget.n);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Delta 15 N',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('density'),
          controller: densityController,
          onChanged: (type) {
            setState(() => densityController.text = type);

            widget.density = densityController.text;
            print(widget.n);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Density (g/cm3)',
          ),
        ),
        if (widget.transformation == false)
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
                  .where((element) => element['sampleType'] == 'sediment')
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
