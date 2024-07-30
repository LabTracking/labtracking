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
import 'package:labtracking/services/sample_service.dart';
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
  String? _selectedOption;
  bool checkin = true;

  final List<String> _options = [
    'Bay',
    'Coastal lagoon',
    'Coastal ocean',
    'Lake',
    'Mangrove soil',
    'Open ocean',
    'Reservoir',
    'River',
    'Others',
  ];
  @override
  final _formKey = GlobalKey<FormState>();

  //String newSample = '';
  //final newSampleController = TextEditingController();
  //final dateController = TextEditingController();
  final dateController = TextEditingController();
  final dateAnalysisController = TextEditingController();
  final entryDateController = TextEditingController();
  final exitDateController = TextEditingController();
  final locationController = TextEditingController();
  final storageConditionController = TextEditingController();
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

  final LocationInput locationInput = LocationInput();

  Future<void> _selectDate(
      BuildContext context, double lat, double long) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        dateController.text =
            selectedDate.toLocal().toString().split(' ')[0].toString();
        locationInput.point?.lat = lat;
        locationInput.point?.long = long;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final newGasSampleForm = NewGasSampleForm(widget.labId, false);
    final newWaterSampleForm = NewWaterSampleForm(widget.labId, false);
    final newSedimentSampleForm = NewSedimentSampleForm(widget.labId, false);
    final newOrganismPartsSampleForm =
        NewOrganismPartsSample(widget.labId, false);

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
          checkin,
          "gas",
          widget.researcherId,
          widget.researcherEmail,
          widget.labId,
          dateController.text,
          entryDateController.text,
          exitDateController.text,
          locationController.text,
          storageConditionController.text,
          observationController.text,
          _selectedOption ?? '',
          newGasSampleForm.gasType,
          newGasSampleForm.chamberType,
          newGasSampleForm.co2,
          newGasSampleForm.ch4,
          newGasSampleForm.no2,
          locationInput.point?.lat!,
          locationInput.point?.long,
          [],
        );
      }

      if (_value == 2) {
        await NewSampleService.saveSediment(
          checkin,
          "sediment",
          widget.researcherId,
          widget.researcherEmail,
          widget.labId,
          dateController.text,
          entryDateController.text,
          exitDateController.text,
          locationController.text,
          storageConditionController.text,
          observationController.text,
          _selectedOption ?? '',
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
          //[],
          //newSedimentSampleForm.previousSample,
        );
      }

      if (_value == 3) {
        await NewSampleService.saveWater(
          checkin,
          "water",
          widget.researcherId,
          widget.researcherEmail,
          widget.labId,
          dateController.text,
          entryDateController.text,
          exitDateController.text,
          locationController.text,
          storageConditionController.text,
          observationController.text,
          ecosystemController.text,
          newWaterSampleForm.waterType ?? '',
          newWaterSampleForm.co2,
          newWaterSampleForm.ch4,
          newWaterSampleForm.no2,
          locationInput.point?.lat,
          locationInput.point?.long,
          //[],
          //newWaterSampleForm.previousSample,
        );
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
            storageConditionController.text,
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
                      const SizedBox(height: 25),
                      TextFormField(
                        key: const ValueKey("date"),
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: 'Sampling date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor:
                              Colors.black12, // Fill color set to transparent
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.lightBlue,
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(context, locationInput.point!.lat!,
                              locationInput.point!.long!);
                        },
                      ),
                      //const SizedBox(height: 15),
                      // TextFormField(
                      //   key: const ValueKey('entryDate'),
                      //   controller: entryDateController,
                      //   onChanged: (type) =>
                      //       setState(() => entryDateController.text = type),
                      //   enabled: true,
                      //   decoration: InputDecoration(
                      //     hintText: 'Entry date',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //       borderSide: BorderSide.none, // Remove border
                      //     ),
                      //     filled: true,
                      //     fillColor:
                      //         Colors.black12, // Fill color set to transparent
                      //     contentPadding:
                      //         EdgeInsets.symmetric(horizontal: 16.0),
                      //   ),
                      // ),
                      const SizedBox(height: 15),
                      TextFormField(
                        key: const ValueKey('storageCondition'),
                        controller: storageConditionController,
                        onChanged: (type) => setState(
                            () => storageConditionController.text = type),
                        enabled: true,
                        decoration: InputDecoration(
                          hintText: 'Storage condition',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            //borderSide: BorderSide.none, // Remove border
                          ),
                          filled: true,
                          fillColor:
                              Colors.black12, // Fill color set to transparent
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),

                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        key: const ValueKey('ecosystem'),
                        decoration: InputDecoration(
                          hintText: 'Select an ecosystem',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            //borderSide: BorderSide.none, // Remove border
                          ),
                          filled: true,
                          fillColor:
                              Colors.black12, // Fill color set to transparent
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        value: _selectedOption,
                        items: _options.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      ),

                      const SizedBox(height: 15),
                      //if (_value == 1) newGasSampleForm,
                      //if (_value == 2) newSedimentSampleForm,
                      if (_value == 3) newWaterSampleForm,
                      //if (_value == 4) newOrganismPartsSampleForm,
                      const SizedBox(height: 15),
                      TextFormField(
                        maxLines: 5,
                        key: const ValueKey('observation'),
                        controller: observationController,
                        onChanged: (type) =>
                            setState(() => observationController.text = type),
                        enabled: true,
                        decoration: InputDecoration(
                          hintText: 'Observations',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            //borderSide: BorderSide.none, // Remove border
                          ),
                          filled: true,
                          fillColor:
                              Colors.black12, // Fill color set to transparent
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
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
