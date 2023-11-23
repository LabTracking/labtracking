import 'package:flutter/material.dart';

class NewWaterSampleForm extends StatefulWidget {
  String waterType = '';
  String co2 = '';
  String ch4 = '';
  String no2 = '';

  NewWaterSampleForm();

  @override
  State<NewWaterSampleForm> createState() => _NewWaterSampleFormState();
}

class _NewWaterSampleFormState extends State<NewWaterSampleForm> {
  final waterTypeController = TextEditingController();
  final co2Controller = TextEditingController();
  final ch4Controller = TextEditingController();
  final no2Controller = TextEditingController();

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
      ],
    );
  }
}
