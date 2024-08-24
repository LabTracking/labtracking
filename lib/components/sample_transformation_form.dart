import 'dart:math';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/models/sediment.dart';
import 'package:labtracking/models/water.dart';
import 'package:labtracking/screens/labs_screen.dart';
import 'package:labtracking/screens/samples_screen.dart';
import 'package:labtracking/screens/track_screen.dart';
import 'package:labtracking/services/sample_service.dart';
import 'package:labtracking/utils/routes.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SampleTransformationForm extends StatefulWidget {
  final Sample sample;

  const SampleTransformationForm({
    required this.sample,
    super.key,
  });

  @override
  State<SampleTransformationForm> createState() =>
      _SampleTransformationFormState();
}

class _SampleTransformationFormState extends State<SampleTransformationForm> {
  @override
  final _formKey = GlobalKey<FormState>();

  final sampleNameController = TextEditingController();
  final dateAnalysisController = TextEditingController();
  final exitDateController = TextEditingController();
  final locationController = TextEditingController();
  final storageConditionController = TextEditingController();
  final observationController = TextEditingController();
  final ecosystemController = TextEditingController();
  final entryDateController = TextEditingController();

  bool isLoading = false;

  bool sampleExistsChanged = false; // Default value is false

  //storageTemperature variables
  List<Map<String, String>> storageTemperature = [];
  bool addStorageTemperature = true;
  String? _selectedStorageTemperatureOption;
  final List<String> _selectedStorageTemperatureOptions = [
    "Frozen",
    "Refrigerated",
    "Ambient air",
    "Other",
  ];
  final temperatureValueController = TextEditingController();
  //end of storageTemperature variables

  Future<bool> _findAndAddSample(
      List<dynamic> samples, Sample newSample) async {
    for (int i = 0; i < samples.length; i++) {
      Map<String, dynamic> sampleData = samples[i];

      if (sampleData['id'] == widget.sample.id) {
        // Found the correct sample, add the new sample to its 'samples' array
        samples[i]['samples'].add(newSample.toMap());
        return true;
      } else if (sampleData['samples'] != null) {
        // Recursively search through sub-samples
        bool found = await _findAndAddSample(sampleData['samples'], newSample);
        if (found) {
          return true;
        }
      }
    }
    return false; // Sample not found
  }

  Future<bool> _findSample(List<dynamic> samples, Sample newSample) async {
    for (int i = 0; i < samples.length; i++) {
      Map<String, dynamic> sampleData = samples[i];

      if (sampleData['id'] == widget.sample.id) {
        // Found the correct sample, add the new sample to its 'samples' array
        //samples[i]['samples'].add(newSample.toMap());
        samples[i]['exists'] = false;
        return true;
      } else if (sampleData['samples'] != null) {
        // Recursively search through sub-samples
        bool found = await _findSample(sampleData['samples'], newSample);
        if (found) {
          return true;
        }
      }
    }
    return false; // Sample not found
  }

  Future<bool> _findAndUpdateSample(
      List<dynamic> samples, String? targetId) async {
    for (int i = 0; i < samples.length; i++) {
      Map<String, dynamic> sampleData = samples[i];

      // Verifica se a amostra é a que precisa ser atualizada
      if (sampleData['id'] == targetId) {
        samples[i]['exists'] = false;
        return true; // Amostra encontrada e atualizada
      } else if (sampleData['samples'] != null &&
          sampleData['samples'].isNotEmpty) {
        // Continua procurando nas sub-amostras
        bool found =
            await _findAndUpdateSample(sampleData['samples'], targetId);
        if (found) {
          return true; // Amostra foi encontrada em algum nível abaixo
        }
      }
    }
    return false; // Amostra não foi encontrada
  }

  @override
  Widget build(BuildContext context) {
    final newGasSampleForm = NewGasSampleForm(widget.sample.labId!, true);
    final newWaterSampleForm = NewWaterSampleForm(widget.sample.labId!, true);
    final newSedimentSampleForm =
        NewSedimentSampleForm(widget.sample.labId!, true);

    //final LocationInput locationInput = LocationInput();

    // Future<void> _selectDate(
    //     BuildContext context, double lat, double long) async {
    //   DateTime? selectedDate = await showDatePicker(
    //     context: context,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime(2000),
    //     lastDate: DateTime(2101),
    //   );

    //   if (selectedDate != null) {
    //     setState(() {
    //       dateController.text =
    //           selectedDate.toLocal().toString().split(' ')[0].toString();
    //       locationInput.point?.lat = lat;
    //       locationInput.point?.long = long;
    //     });
    //   }
    // }

    //submit function start
    void submit() async {
      setState(() {
        isLoading = true;
      });

      if (widget.sample.sampleType == null) {
        return;
      }

      Sample? newSample;

      if (widget.sample.sampleType == "gas") {
        print(widget.sample.researcherEmail);

        newSample = Gas(
          checkin: false,
          sampleType: "gas",

          researcherId: widget.sample.researcherId!,
          researcherEmail: widget.sample.researcherEmail!, // TODO: verificar
          labId: widget.sample.labId!,
          date: widget.sample.date!, //dateController.text,
          entryDate: DateTime.now().toString(), //entryDateController.text,
          exitDate: exitDateController.text,
          location: locationController.text,
          storageCondition: newGasSampleForm.storageCondition!,
          observation: observationController.text,
          ecosystem: widget.sample.ecosystem,
          provider: widget.sample.provider,

          latitude: widget.sample.latitude,
          longitude: widget.sample.longitude,

          level: widget.sample.level != null ? widget.sample.level! + 1 : 1,

          fatherId: widget.sample.id,
          originalSampleId: widget.sample.originalSampleId ?? widget.sample.id,

          exists: true,
          sampleName: sampleNameController.text,

          storageTemperature: storageTemperature,
          samples: [],
          id: "${widget.sample.id}${DateTime.timestamp().millisecondsSinceEpoch}",
        );

        if (sampleExistsChanged == true) {
          var originalSampleDoc = await FirebaseFirestore.instance
              .collection('samples')
              .doc(newSample.originalSampleId)
              .get();

          if (originalSampleDoc.exists) {
            List<dynamic> existingSamples =
                originalSampleDoc.data()!['samples'];

            // Caso a amostra que precisa ser atualizada seja a raiz
            if (widget.sample.id == originalSampleDoc.id) {
              await originalSampleDoc.reference.update({
                'exists': false,
              });
            } else {
              // Procura a amostra específica e atualiza seu atributo 'exists'
              bool found =
                  await _findAndUpdateSample(existingSamples, widget.sample.id);

              if (found) {
                // Atualiza a coleção no Firestore com as mudanças feitas
                await originalSampleDoc.reference.update({
                  'samples': existingSamples,
                });
              } else {
                print(
                    "Erro: Amostra com ID ${widget.sample.id} não foi encontrada.");
              }
            }
          }
        }

        var originalSampleDoc = await FirebaseFirestore.instance
            .collection('samples')
            .doc(newSample.originalSampleId)
            .get();

        if (originalSampleDoc.exists) {
          List<dynamic> existingSamples = originalSampleDoc.data()!['samples'];

          if (widget.sample.id == originalSampleDoc.id) {
            await originalSampleDoc.reference.update({
              'samples': FieldValue.arrayUnion([newSample.toMap()])
            });
          } else {
            bool found = await _findAndAddSample(existingSamples, newSample);

            if (found) {
              await originalSampleDoc.reference
                  .update({'samples': existingSamples});
            } else {
              print(
                  "Error: Sample with ID ${widget.sample.id} not found in original sample.");
            }
          }
        }
      }

      if (widget.sample.sampleType == "sediment") {
        print(widget.sample.researcherEmail);

        newSample = Sediment(
          checkin: false,
          sampleType: "sediment",

          researcherId: widget.sample.researcherId!,
          researcherEmail: widget.sample.researcherEmail!, // TODO: verificar
          labId: widget.sample.labId!,
          date: widget.sample.date,
          provider: widget.sample.provider,
          entryDate: DateTime.now().toString(), //entryDateController.text,
          exitDate: exitDateController.text,
          location: locationController.text,
          storageCondition: newSedimentSampleForm.storageCondition!,
          observation: observationController.text,
          ecosystem: widget.sample.ecosystem!,

          latitude: widget.sample.latitude,
          longitude: widget.sample.longitude,

          level: widget.sample.level != null ? widget.sample.level! + 1 : 1,

          fatherId: widget.sample.id,
          originalSampleId: widget.sample.originalSampleId ?? widget.sample.id,

          exists: true,
          sampleName: sampleNameController.text,

          storageTemperature: storageTemperature,
          samples: [],
          id: "${widget.sample.id}${DateTime.timestamp().millisecondsSinceEpoch}",
        );

        if (sampleExistsChanged == true) {
          var originalSampleDoc = await FirebaseFirestore.instance
              .collection('samples')
              .doc(newSample.originalSampleId)
              .get();

          if (originalSampleDoc.exists) {
            List<dynamic> existingSamples =
                originalSampleDoc.data()!['samples'];

            // Caso a amostra que precisa ser atualizada seja a raiz
            if (widget.sample.id == originalSampleDoc.id) {
              await originalSampleDoc.reference.update({
                'exists': false,
              });
            } else {
              // Procura a amostra específica e atualiza seu atributo 'exists'
              bool found =
                  await _findAndUpdateSample(existingSamples, widget.sample.id);

              if (found) {
                // Atualiza a coleção no Firestore com as mudanças feitas
                await originalSampleDoc.reference.update({
                  'samples': existingSamples,
                });
              } else {
                print(
                    "Erro: Amostra com ID ${widget.sample.id} não foi encontrada.");
              }
            }
          }
        }

        var originalSampleDoc = await FirebaseFirestore.instance
            .collection('samples')
            .doc(newSample.originalSampleId)
            .get();

        if (originalSampleDoc.exists) {
          List<dynamic> existingSamples = originalSampleDoc.data()!['samples'];

          if (widget.sample.id == originalSampleDoc.id) {
            await originalSampleDoc.reference.update({
              'samples': FieldValue.arrayUnion([newSample.toMap()])
            });
          } else {
            bool found = await _findAndAddSample(existingSamples, newSample);

            if (found) {
              await originalSampleDoc.reference
                  .update({'samples': existingSamples});
            } else {
              print(
                  "Error: Sample with ID ${widget.sample.id} not found in original sample.");
            }
          }
        }
      }

      if (widget.sample.sampleType == "water") {
        print(widget.sample.researcherEmail);

        newSample = Water(
          checkin: false,
          sampleType: "water",

          researcherId: widget.sample.researcherId!,
          researcherEmail: widget.sample.researcherEmail!, // TODO: verificar
          labId: widget.sample.labId!,
          date: widget.sample.date,
          provider: widget.sample.provider,
          entryDate: DateTime.now().toString(), //entryDateController.text,
          exitDate: exitDateController.text,
          location: locationController.text,
          storageCondition: newWaterSampleForm.storageCondition,
          observation: observationController.text,
          ecosystem: widget.sample.ecosystem!,

          latitude: widget.sample.latitude,
          longitude: widget.sample.longitude,

          level: widget.sample.level != null ? widget.sample.level! + 1 : 1,

          fatherId: widget.sample.id,
          originalSampleId: widget.sample.originalSampleId ?? widget.sample.id,

          exists: true,
          sampleName: sampleNameController.text,

          storageTemperature: storageTemperature,
          samples: [],
          id: "${widget.sample.id}${DateTime.timestamp().millisecondsSinceEpoch}",
        );

        if (sampleExistsChanged == true) {
          var originalSampleDoc = await FirebaseFirestore.instance
              .collection('samples')
              .doc(newSample.originalSampleId)
              .get();

          if (originalSampleDoc.exists) {
            List<dynamic> existingSamples =
                originalSampleDoc.data()!['samples'];

            // Caso a amostra que precisa ser atualizada seja a raiz
            if (widget.sample.id == originalSampleDoc.id) {
              await originalSampleDoc.reference.update({
                'exists': false,
              });
            } else {
              // Procura a amostra específica e atualiza seu atributo 'exists'
              bool found =
                  await _findAndUpdateSample(existingSamples, widget.sample.id);

              if (found) {
                // Atualiza a coleção no Firestore com as mudanças feitas
                await originalSampleDoc.reference.update({
                  'samples': existingSamples,
                });
              } else {
                print(
                    "Erro: Amostra com ID ${widget.sample.id} não foi encontrada.");
              }
            }
          }
        }

        var originalSampleDoc = await FirebaseFirestore.instance
            .collection('samples')
            .doc(newSample.originalSampleId)
            .get();

        if (originalSampleDoc.exists) {
          List<dynamic> existingSamples = originalSampleDoc.data()!['samples'];

          if (widget.sample.id == originalSampleDoc.id) {
            await originalSampleDoc.reference.update({
              'samples': FieldValue.arrayUnion([newSample.toMap()])
            });
          } else {
            bool found = await _findAndAddSample(existingSamples, newSample);

            if (found) {
              await originalSampleDoc.reference
                  .update({'samples': existingSamples});
            } else {
              print(
                  "Error: Sample with ID ${widget.sample.id} not found in original sample.");
            }
          }
        }
      }

      setState(() {
        isLoading = false;
      });

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => LabsScreen(),
      //   ),
      //   (route) => false,
      // );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => TrackScreen(
      //       sampleId: widget.previousSample,
      //     ),
      //   ),
      // );

      final labData = await FirebaseFirestore.instance
          .collection('labs')
          .doc('${newSample!.labId}')
          .get();
      Navigator.of(context).pop(
        MaterialPageRoute(
          builder: (context) => SamplesScreen(
            labId: widget.sample.labId!,
            labName: labData?['labName'],
            members: List<String>.from(labData?['members']),
          ),
        ),
      );

      Navigator.of(context)
          .pushNamed(AppRoutes.SAMPLE_DETAILS, arguments: newSample);
    }
    //submit function end

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Does the parent sample still exist?'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text("No"),
                            value: true,
                            groupValue: sampleExistsChanged,
                            onChanged: (bool? value) {
                              setState(() {
                                sampleExistsChanged = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text(("Yes").toString()),
                            value: false,
                            groupValue: sampleExistsChanged,
                            onChanged: (bool? value) {
                              setState(() {
                                sampleExistsChanged = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      key: const ValueKey('name'),
                      controller: sampleNameController,
                      onChanged: (type) =>
                          setState(() => sampleNameController.text = type),
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: 'Sample name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          //borderSide: BorderSide.none, // Remove border
                        ),
                        filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            key: const ValueKey('storageTemperature'),
                            decoration: InputDecoration(
                              hintText: 'Storage temp.',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            value: _selectedStorageTemperatureOption,
                            items: _selectedStorageTemperatureOptions
                                .map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStorageTemperatureOption = value;
                                storageTemperature.clear();
                                storageTemperature.add({
                                  _selectedStorageTemperatureOption
                                          .toString() ??
                                      "": temperatureValueController.text
                                });
                                print(storageTemperature);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                            width:
                                16.0), // Space between the dropdown and text field
                        Expanded(
                          child: TextFormField(
                            key: const ValueKey('temperatureValue'),
                            controller: temperatureValueController,
                            keyboardType: TextInputType
                                .number, // Similar to "type='number'" in HTML
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Ensures only numbers are allowed
                            ],
                            decoration: InputDecoration(
                              hintText: 'Ex.: 25°C',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            onChanged: (type) {
                              setState(() {
                                temperatureValueController.text = type;
                                storageTemperature[0]
                                        [_selectedStorageTemperatureOption!] =
                                    temperatureValueController.text;
                                print(storageTemperature);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      maxLines: 5,
                      key: const ValueKey('location'),
                      controller: locationController,
                      onChanged: (type) =>
                          setState(() => locationController.text = type),
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: 'Location in laboratory',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          //borderSide: BorderSide.none, // Remove border
                        ),
                        filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
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
                        ),
                        filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (widget.sample.sampleType == "gas") newGasSampleForm,
                    if (widget.sample.sampleType == "sediment")
                      newSedimentSampleForm,
                    if (widget.sample.sampleType == "water") newWaterSampleForm,
                    isLoading == true
                        ? const Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
