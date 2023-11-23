import 'package:flutter/material.dart';

class NewGasSampleForm extends StatefulWidget {
  String gasType = '';
  String chamberType = '';
  String co2 = '';
  String ch4 = '';
  String no2 = '';

  NewGasSampleForm();

  @override
  State<NewGasSampleForm> createState() => _NewGasSampleFormState();
}

class _NewGasSampleFormState extends State<NewGasSampleForm> {
  final gasTypeController = TextEditingController();
  final chamberTypeController = TextEditingController();
  final co2Controller = TextEditingController();
  final ch4Controller = TextEditingController();
  final no2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('gasType'),
          controller: gasTypeController,
          onChanged: (type) {
            setState(() => gasTypeController.text = type);

            widget.gasType = gasTypeController.text;
            print(widget.gasType);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Gas type',
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          key: const ValueKey('chamberType'),
          controller: chamberTypeController,
          onChanged: (type) {
            setState(() => chamberTypeController.text = type);

            widget.chamberType = chamberTypeController.text;
            print(widget.chamberType);
          },
          enabled: true,
          decoration: const InputDecoration(
            labelText: 'Chamber type',
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
