import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:labtracking/components/location_input.dart';
import 'package:labtracking/components/new_gas_sample_form.dart';
import 'package:labtracking/components/new_sediment_sample_form.dart';
import 'package:labtracking/components/new_water_sample_form.dart';
import 'package:labtracking/components/new_organism_parts_sample_form.dart';
import 'package:labtracking/components/samples_list.dart';
import 'package:labtracking/models/gas.dart';
import 'package:labtracking/models/organism_parts.dart';
import 'package:labtracking/models/sediment.dart';
import 'package:labtracking/models/water.dart';
import 'package:labtracking/services/new_sample_service.dart';
import 'package:labtracking/utils/routes.dart';
import 'package:provider/provider.dart';

class NewSampleForm extends StatefulWidget {
  final String researcherId;
  final String researcherEmail;
  final String labId;

  const NewSampleForm({
    required this.researcherId,
    required this.researcherEmail,
    required this.labId,
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
  //String ecosystemController = '';
  //String ecosystemType = '';

  //final observationController = TextEditingController();

  final double latitude = -22;
  final double longitude = -34;

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

    if (_value == 4) {
      return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final newGasSampleForm = NewGasSampleForm(widget.labId, false);
    final newWaterSampleForm = NewWaterSampleForm(widget.labId, false);
    final newSedimentSampleForm = NewSedimentSampleForm(widget.labId, false);
    final newOrganismPartsSampleForm =
        NewOrganismPartsSample(widget.labId, false);

    final LocationInput locationInput = LocationInput();

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
            widget.labId,
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
            locationInput.point?.lat,
            locationInput.point?.long,
            newGasSampleForm.previousSample);
      }

      if (_value == 2) {
        await NewSampleService.saveSediment(
            Sediment().name,
            widget.researcherId,
            widget.researcherEmail,
            widget.labId,
            dateController.text,
            entryDateController.text,
            exitDateController.text,
            locationController.text,
            historyController.text,
            observationController.text,
            ecosystemController.text,
            newSedimentSampleForm.remineralization ?? '',
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
            locationInput.point?.lat,
            locationInput.point?.long,
            newSedimentSampleForm.previousSample);
      }

      if (_value == 3) {
        await NewSampleService.saveWater(
            Water().name,
            widget.researcherId,
            widget.researcherEmail,
            widget.labId,
            dateController.text,
            entryDateController.text,
            exitDateController.text,
            locationController.text,
            historyController.text,
            observationController.text,
            ecosystemController.text,
            newWaterSampleForm.waterType ?? '',
            newWaterSampleForm.co2,
            newWaterSampleForm.ch4,
            newWaterSampleForm.no2,
            locationInput.point?.lat,
            locationInput.point?.long,
            newWaterSampleForm.previousSample);
      }

      if (_value == 4) {
        await NewSampleService.save(
            OrganismParts().name,
            widget.researcherId,
            widget.researcherEmail,
            widget.labId,
            dateController.text,
            entryDateController.text,
            exitDateController.text,
            locationController.text,
            historyController.text,
            observationController.text,
            ecosystemController.text.toString(),
            locationInput.point?.lat,
            locationInput.point?.long,
            newOrganismPartsSampleForm.previousSample);
      }

      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (ctx) => SamplesList(labId: widget.labId),
      //     fullscreenDialog: true,
      //   ),
      // );
    }

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
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.science,
                        color: getColor(),
                        size: 35,
                      ),
                      const Text(
                        "Sample check-in",
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
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text("Matrix:",
                            style: TextStyle(color: Colors.grey)),
                      ),
                      FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Radio(
                                //contentPadding: const EdgeInsets.all(0),
                                //title: const Text("Gas"),
                                activeColor: const Color(0xFF6200EE),
                                value: 1,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                              ),
                              Text("Gas"),
                            ],
                          ),
                        ),
                      ),

                      FittedBox(
                        child: Row(
                          children: [
                            Radio(
                              //contentPadding: const EdgeInsets.all(0),
                              //title: const Text("Sediment"),
                              activeColor: Colors.orange,
                              value: 2,
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                            ),
                            Text("Soil/sediment"),
                          ],
                        ),
                      ),

                      FittedBox(
                        child: Row(
                          children: [
                            Radio(
                              //contentPadding: const EdgeInsets.all(0),
                              //title: const Text("Water"),
                              activeColor: Colors.lightBlue,
                              value: 3,
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                            ),
                            Text("Water"),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Row(
                      //     children: [
                      //       Radio(
                      //         //contentPadding: const EdgeInsets.all(0),
                      //         //title: const Text("Organism parts"),
                      //         activeColor: Colors.greenAccent,
                      //         value: 4,
                      //         groupValue: _value,
                      //         onChanged: (value) {
                      //           setState(() {
                      //             _value = value;
                      //           });
                      //         },
                      //       ),
                      //       const Expanded(
                      //           child: FittedBox(
                      //               child: Text("Organism\n    parts"))),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_value != null)
                  Column(
                    children: [
                      locationInput,
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
                      //Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Row(
                      //     //crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Text(
                      //         'Ecosystem Type',
                      //         style: TextStyle(fontSize: 16.0),
                      //       ),
                      //       SizedBox(
                      //         width: 15,
                      //       ),
                      //       DropdownButton<String>(
                      //         value: ecosystemController,
                      //         icon: Icon(Icons.arrow_downward),
                      //         iconSize: 24,
                      //         elevation: 16,
                      //         style: TextStyle(color: Colors.blue),
                      //         underline: Container(
                      //           height: 2,
                      //           color: Colors.blue,
                      //         ),
                      //         onChanged: (newValue) {
                      //           setState(() {
                      //             ecosystemController =
                      //                 newValue.toString() ?? '';
                      //             ecosystemType = ecosystemController;
                      //           });
                      //         },
                      //         items: <String>[
                      //           'Bay',
                      //           'Coastal lagoon',
                      //           'Coastal ocean',
                      //           'Lake',
                      //           'Mangrove soil',
                      //           'Open ocean',
                      //           'Reservoir',
                      //           'River',
                      //           'Others',
                      //         ].map<DropdownMenuItem<String>>((value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 5),
                      if (_value == 1) newGasSampleForm,
                      if (_value == 2) newSedimentSampleForm,
                      if (_value == 3) newWaterSampleForm,
                      if (_value == 4) newOrganismPartsSampleForm,
                      isLoading == true
                          ? const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: CircularProgressIndicator(
                                backgroundColor:
                                    Color.fromARGB(255, 92, 225, 230),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 126, 217, 87),
                                ),
                                onPressed: submit,
                                child: const Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
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
