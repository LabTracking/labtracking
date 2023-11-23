import 'package:flutter/material.dart';

class NewSedimentSampleForm extends StatefulWidget {
  String remineralization = '';
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

  NewSedimentSampleForm();

  @override
  State<NewSedimentSampleForm> createState() => _NewSedimentSampleFormState();
}

class _NewSedimentSampleFormState extends State<NewSedimentSampleForm> {
  final remineralizationController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: const ValueKey('remineralization'),
          controller: remineralizationController,
          onChanged: (type) {
            setState(() => remineralizationController.text = type);

            widget.remineralization = remineralizationController.text;
            print(widget.remineralization);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Remineralization',
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
      ],
    );
  }
}
