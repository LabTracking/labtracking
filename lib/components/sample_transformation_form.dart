import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import 'package:labtracking/components/new_gas_sample_form.dart';
import 'package:labtracking/components/new_sediment_sample_form.dart';
import 'package:labtracking/components/new_water_sample_form.dart';

import 'package:labtracking/models/gas.dart';

import 'package:labtracking/models/sample.dart';
import 'package:labtracking/models/sediment.dart';
import 'package:labtracking/models/water.dart';

import 'package:labtracking/screens/sample_details_screen.dart';
import 'package:labtracking/screens/samples_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SampleTransformationForm extends StatefulWidget {
  final Sample sample;
  final Map<String, dynamic> researcherData;
  final Sample mainSample;

  const SampleTransformationForm({
    required this.sample,
    required this.researcherData,
    required this.mainSample,
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
  final weightController = TextEditingController();
  final dateAnalysisController = TextEditingController();
  final exitDateController = TextEditingController();
  final locationController = TextEditingController();
  final storageConditionController = TextEditingController();
  final observationController = TextEditingController();
  final ecosystemController = TextEditingController();
  final entryDateController = TextEditingController();

  NewGasSampleForm? newGasSampleForm;
  NewWaterSampleForm? newWaterSampleForm;
  NewSedimentSampleForm? newSedimentSampleForm;

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

  //analysis variables and functions
  List<Map<String, String>> analysis = [];
  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _resultControllers = [];

// Method to add analysis input fields
  void _addAnalysisFields() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _resultControllers.add(TextEditingController());
    });
  }

// Method to save the analysis data into a list
  void _saveAnalysis() {
    analysis.clear(); // Clear existing analysis data before saving

    for (int i = 0; i < _nameControllers.length; i++) {
      String name = _nameControllers[i].text.trim();
      String result = _resultControllers[i].text.trim();

      if (name.isNotEmpty && result.isNotEmpty) {
        setState(() {
          analysis.add({
            'name': name,
            'result': result,
          });
        });
      } else {
        setState(() {
          analysis.add({
            '': '',
          });
        });
      }
    }

    print(analysis); // Debugging: Print the analysis data to the console
  }

// Widget to display the analysis form fields dynamically
  Widget _buildAnalysisForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_nameControllers.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameControllers[index],
                  decoration: InputDecoration(
                    hintText: 'Analysis name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.black12, // Fill color set to transparent
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _resultControllers[index],
                  decoration: InputDecoration(
                    hintText: 'Result',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.black12, // Fill color set to transparent
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    _nameControllers.removeAt(index);
                    _resultControllers.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }
  //end of analysis variables and functions

  Future<bool> _findAndAddSample(
      List<dynamic> samples, Sample newSample) async {
    for (int i = 0; i < samples.length; i++) {
      Map<String, dynamic> sampleData = samples[i];

      if (sampleData['id'] == widget.sample.id) {
        // Found the correct sample, add the new sample to its 'samples' array
        samples[i]['samples'].add(newSample.toMap());
        samples[i]['sonIds'].add(newSample.id);
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
  void initState() {
    newGasSampleForm = NewGasSampleForm(widget.sample.labId!, true);
    newWaterSampleForm = NewWaterSampleForm(widget.sample.labId!, true);
    newSedimentSampleForm = NewSedimentSampleForm(widget.sample.labId!, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          storageCondition: newGasSampleForm!.storageCondition ?? "Other",
          observation: observationController.text,
          ecosystem: widget.sample.ecosystem,
          provider: widget.sample.provider,

          weight: weightController.text ?? "",

          latitude: widget.sample.latitude,
          longitude: widget.sample.longitude,

          level: widget.sample.level != null ? widget.sample.level! + 1 : 1,

          fatherId: widget.sample.id,
          originalSampleId: widget.sample.originalSampleId ?? widget.sample.id,

          exists: true,
          sampleName: sampleNameController.text,

          storageTemperature: storageTemperature,
          analysis: analysis,
          samples: [],
          sonIds: [],
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

            List<dynamic> existingSonIds = originalSampleDoc.data()!['sonIds'];

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
                  'sonIds': existingSonIds,
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

          List<dynamic> existingSonIds = originalSampleDoc.data()!['sonIds'];

          if (widget.sample.id == originalSampleDoc.id) {
            await originalSampleDoc.reference.update({
              'samples': FieldValue.arrayUnion([newSample.toMap()]),
              'sonIds': FieldValue.arrayUnion([newSample.id]),
            });
          } else {
            bool found = await _findAndAddSample(existingSamples, newSample);

            if (found) {
              await originalSampleDoc.reference.update({
                'samples': existingSamples,
                'sonIds': existingSonIds,
              });
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
          weight: weightController.text ?? "",
          entryDate: DateTime.now().toString(), //entryDateController.text,
          exitDate: exitDateController.text,
          location: locationController.text,
          storageCondition: newSedimentSampleForm!.storageCondition ?? "Other",
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
          analysis: analysis,
          samples: [],

          sonIds: [],

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

            List<dynamic> existingSonIds = originalSampleDoc.data()!['sonIds'];

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
                  'sonIds': existingSonIds,
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

          List<dynamic> existingSonIds = originalSampleDoc.data()!['sonIds'];

          if (widget.sample.id == originalSampleDoc.id) {
            await originalSampleDoc.reference.update({
              'samples': FieldValue.arrayUnion([newSample.toMap()]),
              'sonIds': FieldValue.arrayUnion([newSample.id]),
            });
          } else {
            bool found = await _findAndAddSample(existingSamples, newSample);

            if (found) {
              await originalSampleDoc.reference.update({
                'samples': existingSamples,
                'sonIds': existingSonIds,
              });
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
          weight: weightController.text ?? "",
          entryDate: DateTime.now().toString(), //entryDateController.text,
          exitDate: exitDateController.text,
          location: locationController.text,
          storageCondition: newWaterSampleForm!.storageCondition ?? "Other",
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
          analysis: analysis,
          samples: [],
          sonIds: [],

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

            List<dynamic> existingSonIds = originalSampleDoc.data()!['sonIds'];

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
                  'sonIds': existingSonIds,
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

          List<dynamic> existingSonIds = originalSampleDoc.data()!['sonIds'];

          if (widget.sample.id == originalSampleDoc.id) {
            await originalSampleDoc.reference.update({
              'samples': FieldValue.arrayUnion([newSample.toMap()]),
              'sonIds': FieldValue.arrayUnion([newSample.id]),
            });
          } else {
            bool found = await _findAndAddSample(existingSamples, newSample);

            if (found) {
              await originalSampleDoc.reference.update({
                'samples': existingSamples,
                'sonIds': existingSonIds,
              });
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

      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('labs')
            .doc(widget.sample.labId)
            .get();

        // Verifica se o documento existe
        if (snapshot.exists) {
          var labData = snapshot.data() as Map<String, dynamic>;

          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('researchers')
              .where('email', isEqualTo: labData['createdBy'])
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot snapshotResearcher = querySnapshot.docs.first;
            Map<String, dynamic>? researcherData =
                snapshotResearcher.data() as Map<String, dynamic>?;
            print('Researcher Data: $researcherData');
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SamplesScreen(
            //       labId: widget.sample.labId!,
            //       labName: labData["labName"],
            //       members: labData["members"] ?? [],
            //       researcherData: researcherData!,
            //     ),
            //   ),
            //   (route) => false,
            // );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (ctx) => SampleDetailsScreen(
            //       sample: newSample!,
            //       researcherData: researcherData!,
            //       mainSample: widget.mainSample,
            //     ),
            //   ),
            // );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => SampleDetailsScreen(
                  sample: newSample!,
                  researcherData: researcherData!,
                  mainSample: widget.mainSample,
                ),
              ),
            );
          } else {
            print('No researcher found with the provided email.');
          }
        }
      } catch (e) {
        print("Erro ao obter dados do laboratório: $e");
      }
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
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Column(
                        children: [
                          const Text('Does the parent sample still exist?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text("No"),
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
                                  title: Text(
                                    ("Yes").toString(),
                                  ),
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
                        ],
                      ),
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
                        labelText: 'Sample name *',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          //borderSide: BorderSide.none, // Remove border
                        ),
                        filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sample name is required';
                        }
                        return null; // Return null if validation passes
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      key: const ValueKey('weight'),
                      controller: weightController,
                      onChanged: (value) =>
                          setState(() => weightController.text = value),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'^\d*\.?\d*')), // Only allow numbers and a single decimal point
                      ],
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: 'Enter weight (g)',
                        labelText: 'Weight (g)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^\d*\.?\d*$').hasMatch(value)) {
                            return 'Please enter a valid weight (numbers only)';
                          }
                        }
                        return null; // Validation passed or input is empty
                      },
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
                    //const SizedBox(height: 15),
                    // TextFormField(
                    //   key: const ValueKey('storageCondition'),
                    //   controller: storageConditionController,
                    //   onChanged: (type) => setState(
                    //       () => storageConditionController.text = type),
                    //   enabled: true,
                    //   decoration: InputDecoration(
                    //     hintText: 'Storage condition',
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //       //borderSide: BorderSide.none, // Remove border
                    //     ),
                    //     filled: true,
                    //     fillColor:
                    //         Colors.black12, // Fill color set to transparent
                    //     contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    //   ),
                    // ),
                    const SizedBox(height: 15),
                    TextFormField(
                      maxLines: 4,
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
                      maxLines: 4,
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
                    if (widget.sample.sampleType == "gas") newGasSampleForm!,
                    if (widget.sample.sampleType == "sediment")
                      newSedimentSampleForm!,
                    if (widget.sample.sampleType == "water")
                      newWaterSampleForm!,
                    Column(
                      children: [
                        TextButton(
                          onPressed: _addAnalysisFields,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.blue,
                              ),
                              Text(
                                'Add Analysis',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),

                        // Analysis form fields
                        _buildAnalysisForm(),

                        // Submit button
                        // ElevatedButton(
                        //   onPressed: () {
                        //     _saveAnalysis();
                        //     // Submit form logic here...
                        //   },
                        //   child: isLoading
                        //       ? const CircularProgressIndicator()
                        //       : const Text('Submit'),
                        // ),
                      ],
                    ),
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 126, 217, 87),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _saveAnalysis();
                                    submit();
                                  }
                                },
                                child: const Text(
                                  "Save sample",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
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
