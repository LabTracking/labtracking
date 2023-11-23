import 'package:flutter/material.dart';
import 'package:labtracking/components/new_gas_sample_form.dart';
import 'package:labtracking/components/new_sediment_sample_form.dart';
import 'package:labtracking/components/new_water_sample_form.dart';
import 'package:labtracking/models/gas.dart';
import 'package:labtracking/models/sediment.dart';
import 'package:labtracking/models/water.dart';
import 'package:labtracking/services/new_sample_service.dart';
import 'package:labtracking/utils/routes.dart';

class NewSampleForm extends StatefulWidget {
  final String researcherId;
  final String researcherEmail;

  const NewSampleForm({
    required this.researcherId,
    required this.researcherEmail,
    super.key,
  });

  @override
  State<NewSampleForm> createState() => _NewSampleFormState();
}

class _NewSampleFormState extends State<NewSampleForm> {
  @override
  final _formKey = GlobalKey<FormState>();

  //String newSample = '';
  //final newSampleController = TextEditingController();
  final dateController = TextEditingController();
  final dateAnalysisController = TextEditingController();
  final entryDateController = TextEditingController();
  final exitDateController = TextEditingController();
  final locationController = TextEditingController();
  final historyController = TextEditingController();
  final observationController = TextEditingController();
  final ecosystemController = TextEditingController();
  //final observationController = TextEditingController();

  final newGasSampleForm = NewGasSampleForm();
  final newWaterSampleForm = NewWaterSampleForm();
  final newSedimentSampleForm = NewSedimentSampleForm();

  bool isLoading = false;

  int? _value;

  Color? getColor() {
    if (_value == null) {
      return Color.fromARGB(255, 126, 217, 87);
    }

    if (_value == 1) {
      return Color(0xFF6200EE);
    }

    if (_value == 2) {
      return Colors.orange;
    }

    if (_value == 3) {
      return Colors.lightBlue;
    }
  }

  void submit() async {
    setState(() {
      isLoading = true;
    });

    // if (widget.email == null) {
    //   return;
    // }

    if (_value == null) {
      return;
    }

    if (_value == 1) {
      print(widget.researcherEmail);
      await NewSampleService.saveGas(
        Gas().name,
        widget.researcherId,
        widget.researcherEmail,
        dateController.text,
        entryDateController.text,
        exitDateController.text,
        locationController.text,
        historyController.text,
        observationController.text,
        ecosystemController.text,
        newGasSampleForm.gasType,
        newGasSampleForm.chamberType,
        newGasSampleForm.co2,
        newGasSampleForm.ch4,
        newGasSampleForm.no2,
      );
    }

    if (_value == 2) {
      await NewSampleService.saveSediment(
        Sediment().name,
        widget.researcherId,
        widget.researcherEmail,
        dateController.text,
        entryDateController.text,
        exitDateController.text,
        locationController.text,
        historyController.text,
        observationController.text,
        ecosystemController.text,
        newSedimentSampleForm.remineralization,
        newSedimentSampleForm.co2,
        newSedimentSampleForm.ch4,
        newSedimentSampleForm.no2,
        newSedimentSampleForm.sand,
        newSedimentSampleForm.silt,
        newSedimentSampleForm.clay,
        newSedimentSampleForm.n,
        newSedimentSampleForm.delta13c,
        newSedimentSampleForm.delta15n,
        newSedimentSampleForm.density,
      );
    }

    if (_value == 3) {
      await NewSampleService.saveWater(
        Water().name,
        widget.researcherId,
        widget.researcherEmail,
        dateController.text,
        entryDateController.text,
        exitDateController.text,
        locationController.text,
        historyController.text,
        observationController.text,
        ecosystemController.text,
        newGasSampleForm.gasType,
        newGasSampleForm.co2,
        newGasSampleForm.ch4,
        newGasSampleForm.no2,
      );
    }

    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushNamed(AppRoutes.SAMPLES);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: getColor(),
                        size: 35,
                      ),
                      Text(
                        "Add new sample",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey,
                          shadows: [
                            Shadow(
                              color: Colors
                                  .black12, // Choose the color of the shadow
                              blurRadius:
                                  1.0, // Adjust the blur radius for the shadow effect
                              offset: Offset(2.0,
                                  1.0), // Set the horizontal and vertical offset for the shadow
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                RadioListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Gas"),
                  activeColor: const Color(0xFF6200EE),
                  value: 1,
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                RadioListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Sediment"),
                  activeColor: Colors.orange,
                  value: 2,
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                RadioListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Water"),
                  activeColor: Colors.lightBlue,
                  value: 3,
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                if (_value != null)
                  Column(
                    children: [
                      TextFormField(
                        key: const ValueKey('date'),
                        controller: dateController,
                        onChanged: (type) =>
                            setState(() => dateController.text = type),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Sample date',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        key: const ValueKey('dateAnalysis'),
                        controller: dateAnalysisController,
                        onChanged: (type) =>
                            setState(() => dateAnalysisController.text = type),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Analysis date',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        key: const ValueKey('entryDate'),
                        controller: entryDateController,
                        onChanged: (type) =>
                            setState(() => entryDateController.text = type),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Entry date',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        key: const ValueKey('exitDate'),
                        controller: exitDateController,
                        onChanged: (type) =>
                            setState(() => exitDateController.text = type),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Exit date',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        key: const ValueKey('location'),
                        controller: locationController,
                        onChanged: (type) =>
                            setState(() => locationController.text = type),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        key: const ValueKey('history'),
                        controller: historyController,
                        onChanged: (type) =>
                            setState(() => historyController.text = type),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'History',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        key: const ValueKey('observation'),
                        controller: observationController,
                        onChanged: (type) =>
                            setState(() => observationController.text = type),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Observation',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        key: const ValueKey('ecosystem'),
                        controller: ecosystemController,
                        onChanged: (type) =>
                            setState(() => ecosystemController.text = type),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Ecosystem',
                        ),
                      ),
                      if (_value == 1) newGasSampleForm,
                      if (_value == 2) newSedimentSampleForm,
                      if (_value == 3) newWaterSampleForm,
                      isLoading == true
                          ? const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: CircularProgressIndicator(
                                backgroundColor:
                                    Color.fromARGB(255, 92, 225, 230),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ElevatedButton(
                                onPressed: submit,
                                child: const Text("Add"),
                              ),
                            )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
