import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/components/new_gas_sample_form.dart';
import 'package:labtracking/components/new_sediment_sample_form.dart';
import 'package:labtracking/components/new_water_sample_form.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/screens/samples_screen.dart';
import 'package:labtracking/services/sample_service.dart';

class EditSample extends StatefulWidget {
  final Sample sample;
  final Map<String, dynamic> researcherData;
  const EditSample({
    required this.researcherData,
    required this.sample,
    super.key,
  });

  @override
  State<EditSample> createState() => _EditSampleState();
}

class _EditSampleState extends State<EditSample> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController sampleNameController = TextEditingController();

  TextEditingController weightController = TextEditingController();

  TextEditingController dateAnalysisController = TextEditingController();
  TextEditingController exitDateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController storageConditionController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  //TextEditingController ecosystemController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();

  NewGasSampleForm? newGasSampleForm;
  NewWaterSampleForm? newWaterSampleForm;
  NewSedimentSampleForm? newSedimentSampleForm;

  bool isLoading = false;
  bool sampleExistsChanged = false;

  //storageTemperature variables
  List storageTemperature = [];
  String? _selectedStorageTemperatureOption;
  final List<String> _selectedStorageTemperatureOptions = [
    "Frozen",
    "Refrigerated",
    "Ambient air",
    "Other",
  ];
  final temperatureValueController = TextEditingController();

  //analysis variables and functions
  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _resultControllers = [];

  //ecosystem
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
  //

  @override
  void initState() {
    newGasSampleForm = NewGasSampleForm(widget.sample.labId!, false,
        storageCondition: widget.sample.storageCondition);
    newWaterSampleForm = NewWaterSampleForm(widget.sample.labId!, false,
        storageCondition: widget.sample.storageCondition);
    newSedimentSampleForm = NewSedimentSampleForm(widget.sample.labId!, false,
        storageCondition: widget.sample.storageCondition);

    super.initState();

    // Pre-fill form fields with Sample values
    sampleNameController.text = widget.sample.sampleName ?? '';

    weightController.text = widget.sample.weight ?? '';

    dateAnalysisController.text = widget.sample.date ?? '';

    locationController.text = widget.sample.location ?? '';

    if (widget.sample.sampleType == "gas") {
      setState(() {
        newGasSampleForm!.storageCondition =
            widget.sample.storageCondition ?? '';
      });
    }

    if (widget.sample.sampleType == "sediment") {
      setState(() {
        newSedimentSampleForm!.storageCondition =
            widget.sample.storageCondition ?? '';
      });
    }

    if (widget.sample.sampleType == "water") {
      setState(() {
        newWaterSampleForm!.storageCondition =
            widget.sample.storageCondition ?? '';
      });
    }

    observationController.text = widget.sample.observation ?? '';
    //ecosystemController.text = widget.sample.ecosystem ?? '';
    _selectedOption = widget.sample.ecosystem;
    entryDateController.text = widget.sample.entryDate ?? '';
    exitDateController.text = widget.sample.exitDate ?? '';
    sampleExistsChanged = widget.sample.exists ?? true;

    // Ensure `storageTemperature` is correctly typed and initialized
    if (widget.sample.storageTemperature != null &&
        widget.sample.storageTemperature!.isNotEmpty) {
      storageTemperature = List.from(widget.sample.storageTemperature!);

      // Assuming the first item in storageTemperature is valid
      if (storageTemperature.isNotEmpty) {
        print("===============AQUI" + storageTemperature.toString());
        _selectedStorageTemperatureOption = storageTemperature[0].keys.first;
        temperatureValueController.text = storageTemperature[0].values.first;
      }
    }

    // If the sample has analysis data, initialize the controllers
    if (widget.sample.analysis != null) {
      for (var analysis in widget.sample.analysis!) {
        _nameControllers.add(TextEditingController(text: analysis['name']));
        _resultControllers.add(TextEditingController(text: analysis['result']));
      }
    }
  }

  // Method to add analysis input fields
  void _addAnalysisFields() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _resultControllers.add(TextEditingController());
    });
  }

  // Method to save the analysis data into a list
  void _saveAnalysis() {
    widget.sample.analysis = [];
    if (_nameControllers.isNotEmpty) {
      for (int i = 0; i < _nameControllers.length; i++) {
        String name = _nameControllers[i].text.trim();
        String result = _resultControllers[i].text.trim();

        if (name.isNotEmpty && result.isNotEmpty) {
          setState(() {
            widget.sample.analysis!.add({'name': name, 'result': result});
          });
        }
      }
    }
  }

  // Widget to display the analysis form fields dynamically
  Widget _buildAnalysisForm() {
    return Column(
      children: List.generate(_nameControllers.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
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
                    fillColor: Colors.black12,
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
                    fillColor: Colors.black12,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
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

  @override
  void dispose() {
    sampleNameController.dispose();
    dateAnalysisController.dispose();
    exitDateController.dispose();
    locationController.dispose();
    //storageConditionController.dispose();
    observationController.dispose();
    //ecosystemController.dispose();
    entryDateController.dispose();
    temperatureValueController.dispose();

    // Dispose analysis controllers
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _resultControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> selectDate(BuildContext context) async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: entryDateController.text.isNotEmpty
            ? DateTime.parse(entryDateController.text)
            : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (selectedDate != null) {
        // Usa DateFormat para formatar a data
        entryDateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      }
    }

    Future<void> selectExitDate(BuildContext context) async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: entryDateController.text.isNotEmpty
            ? DateTime.parse(entryDateController.text)
            : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (selectedDate != null) {
        // Usa DateFormat para formatar a data
        exitDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      }
    }

    return Scaffold(
      appBar: LabTrackingBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_document, color: Colors.blue),
                    Text(
                      " Edit sample",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
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
                                const Text('Does this sample still exist?'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: const Text("Yes"),
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
                                        title: const Text("No"),
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
                            decoration: InputDecoration(
                              hintText: 'Sample name',
                              labelText: 'Sample name *',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 2) {
                                return 'Sample name is required and must have more than 2 chars.';
                              }
                              return null; // Return null if validation passes
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('weight'),
                            controller: weightController,
                            // onChanged: (value) =>
                            //     setState(() => weightController.text = value),
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors
                                  .black12, // Fill color set to transparent
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
                                    labelText: 'Storage temp.',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black12,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
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
                                      if (storageTemperature.isNotEmpty) {
                                        storageTemperature[0] = {
                                          _selectedStorageTemperatureOption!:
                                              temperatureValueController.text
                                        };
                                      } else {
                                        storageTemperature.add({
                                          _selectedStorageTemperatureOption!:
                                              temperatureValueController.text
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: TextFormField(
                                  key: const ValueKey('temperatureValue'),
                                  controller: temperatureValueController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d*)'))
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'Temp. value (°C)',
                                    labelText: 'Temp. value (°C)',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black12,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // TextFormField(
                          //   key: const ValueKey('entryDate'),
                          //   controller: entryDateController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Entry date (dd/mm/yyyy)',
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(12.0),
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors.black12,
                          //     contentPadding:
                          //         const EdgeInsets.symmetric(horizontal: 16.0),
                          //   ),
                          // ),
                          TextFormField(
                              key: const ValueKey("entryDate"),
                              controller: entryDateController,
                              decoration: InputDecoration(
                                hintText: 'Entry date',
                                labelText: 'Entry date *',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: Colors
                                    .black12, // Fill color set to transparent
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.lightBlue,
                                ),
                              ),
                              readOnly: true,
                              onTap: () {
                                selectDate(context);
                              }),
                          const SizedBox(height: 15),
                          if (!widget.sample.exists! || !sampleExistsChanged)
                            TextFormField(
                                key: const ValueKey("exitDate"),
                                controller: exitDateController,
                                decoration: InputDecoration(
                                  hintText: 'Exit date',
                                  labelText: 'Exit date',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors
                                      .black12, // Fill color set to transparent
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                readOnly: true,
                                onTap: () {
                                  selectExitDate(context);
                                }),
                          if (!widget.sample.exists! || !sampleExistsChanged)
                            const SizedBox(height: 15),
                          TextFormField(
                            maxLines: 4,
                            key: const ValueKey('location'),
                            controller: locationController,
                            decoration: InputDecoration(
                              hintText: 'Location',
                              labelText: 'Location',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                          ),
                          //const SizedBox(height: 15),
                          // TextFormField(
                          //   key: const ValueKey('ecosystem'),
                          //   controller: ecosystemController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Ecosystem',
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(12.0),
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors.black12,
                          //     contentPadding:
                          //         const EdgeInsets.symmetric(horizontal: 16.0),
                          //   ),
                          // ),
                          // DropdownButtonFormField<String>(
                          //   key: const ValueKey('ecosystem'),
                          //   decoration: InputDecoration(
                          //     hintText: 'Select an ecosystem',
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(12.0),
                          //       //borderSide: BorderSide.none, // Remove border
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors
                          //         .black12, // Fill color set to transparent
                          //     contentPadding:
                          //         const EdgeInsets.symmetric(horizontal: 16.0),
                          //   ),
                          //   value: widget.sample.ecosystem ?? "Other",
                          //   items: _options.map((option) {
                          //     return DropdownMenuItem<String>(
                          //       value: option,
                          //       child: Text(option),
                          //     );
                          //   }).toList(),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _selectedOption = value;
                          //     });
                          //   },
                          // ),
                          //const SizedBox(height: 15),
                          // TextFormField(
                          //   key: const ValueKey('storageCondition'),
                          //   controller: storageConditionController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Storage condition',
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(12.0),
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors.black12,
                          //     contentPadding:
                          //         const EdgeInsets.symmetric(horizontal: 16.0),
                          //   ),
                          // ),
                          // const SizedBox(height: 15),
                          // TextFormField(
                          //   key: const ValueKey('dateAnalysis'),
                          //   controller: dateAnalysisController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Date of analysis (dd/mm/yyyy)',
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(12.0),
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors.black12,
                          //     contentPadding:
                          //         const EdgeInsets.symmetric(horizontal: 16.0),
                          //   ),
                          // ),
                          if (widget.sample.sampleType == "gas")
                            newGasSampleForm!,
                          if (widget.sample.sampleType == "sediment")
                            newSedimentSampleForm!,
                          if (widget.sample.sampleType == "water")
                            newWaterSampleForm!,
                          const SizedBox(height: 15),
                          TextFormField(
                            maxLines: 4,
                            key: const ValueKey('observation'),
                            controller: observationController,
                            decoration: InputDecoration(
                              hintText: 'Observations',
                              labelText: 'Obs.',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildAnalysisForm(),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _addAnalysisFields,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 8.0),
                                Text('Add Analysis')
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Salva as análises do formulário antes de prosseguir
                                _saveAnalysis();

                                String mainSampleId =
                                    widget.sample.id!.substring(0, 20);
                                String sampleId = widget.sample.id!;

                                // Mapa para armazenar os dados atualizados
                                Map<String, dynamic> updatedData = {};

                                // Adiciona os campos que foram editados no formulário
                                if (sampleNameController.text !=
                                    widget.sample.sampleName) {
                                  updatedData['sampleName'] =
                                      sampleNameController.text;
                                }

                                if (weightController.text !=
                                    widget.sample.weight) {
                                  updatedData['weight'] = weightController.text;
                                }

                                if (dateAnalysisController.text !=
                                    widget.sample.date) {
                                  updatedData['date'] =
                                      dateAnalysisController.text;
                                }

                                if (locationController.text !=
                                    widget.sample.location) {
                                  updatedData['location'] =
                                      locationController.text;
                                }

                                // if (storageConditionController.text !=
                                //     widget.sample.storageCondition) {
                                //   updatedData['storageCondition'] =
                                //       storageConditionController.text;
                                // }

                                if (widget.sample.sampleType == "gas") {
                                  if (newGasSampleForm!.storageCondition !=
                                      widget.sample.storageCondition) {
                                    updatedData['storageCondition'] =
                                        newGasSampleForm!.storageCondition;
                                  }
                                } else if (widget.sample.sampleType ==
                                    "sediment") {
                                  if (newSedimentSampleForm!.storageCondition !=
                                      widget.sample.storageCondition) {
                                    updatedData['storageCondition'] =
                                        newSedimentSampleForm!.storageCondition;
                                  }
                                } else if (widget.sample.sampleType ==
                                    "water") {
                                  if (newWaterSampleForm!.storageCondition !=
                                      widget.sample.storageCondition) {
                                    updatedData['storageCondition'] =
                                        newWaterSampleForm!.storageCondition;
                                  }
                                }

                                if (observationController.text !=
                                    widget.sample.observation) {
                                  updatedData['observation'] =
                                      observationController.text;
                                }
                                if (_selectedOption !=
                                    widget.sample.ecosystem) {
                                  updatedData['ecosystem'] = _selectedOption;
                                }
                                if (entryDateController.text !=
                                    widget.sample.entryDate) {
                                  updatedData['entryDate'] =
                                      entryDateController.text;
                                }

                                if (exitDateController.text !=
                                    widget.sample.exitDate) {
                                  updatedData['exitDate'] =
                                      exitDateController.text;
                                }

                                // Verifica se o estado da amostra foi alterado
                                if (sampleExistsChanged !=
                                    (widget.sample.exists ?? true)) {
                                  updatedData['exists'] = sampleExistsChanged;
                                }

                                // Verifica se a temperatura de armazenamento foi alterada
                                if (storageTemperature.isNotEmpty) {
                                  updatedData["storageTemperature"] = [
                                    {
                                      storageTemperature[0].keys.first ?? "":
                                          temperatureValueController.text
                                    }
                                  ];
                                }

                                // if (storageTemperature.isNotEmpty &&
                                //     storageTemperature[0].keys.first !=
                                //         _selectedStorageTemperatureOption) {
                                //   updatedData['storageTemperature'] =
                                //       storageTemperature;
                                //   print(storageTemperature.toString() +
                                //       "===============================");
                                //   //   {
                                //   //     _selectedStorageTemperatureOption:
                                //   //         temperatureValueController.text,
                                //   //   }
                                //   // ];

                                // }

                                // Atualiza a análise
                                if (_nameControllers.isNotEmpty) {
                                  List<Map<String, dynamic>> newAnalyses = [];

                                  for (int i = 0;
                                      i < _nameControllers.length;
                                      i++) {
                                    String name =
                                        _nameControllers[i].text.trim();
                                    String result =
                                        _resultControllers[i].text.trim();

                                    // Adiciona apenas análises não vazias
                                    if (name.isNotEmpty && result.isNotEmpty) {
                                      newAnalyses.add(
                                          {'name': name, 'result': result});
                                    }
                                  }

                                  // Se houver novas análises, atualiza no mapa de dados
                                  if (newAnalyses.isNotEmpty) {
                                    updatedData['analysis'] = newAnalyses;
                                  }
                                }

                                // Apenas chama a função de salvar se houver dados para atualizar
                                if (updatedData.isNotEmpty) {
                                  await NewSampleService.saveSampleEdits(
                                      mainSampleId, sampleId, updatedData);
                                }

                                try {
                                  DocumentSnapshot snapshot =
                                      await FirebaseFirestore.instance
                                          .collection('labs')
                                          .doc(widget.sample.labId)
                                          .get();

                                  // Verifica se o documento existe
                                  if (snapshot.exists) {
                                    var labData =
                                        snapshot.data() as Map<String, dynamic>;

                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('researchers')
                                            .where('email',
                                                isEqualTo: labData['createdBy'])
                                            .get();
                                    if (querySnapshot.docs.isNotEmpty) {
                                      // Navega de volta para a tela de amostras
                                      DocumentSnapshot snapshotResearcher =
                                          querySnapshot.docs.first;
                                      Map<String, dynamic>? researcherData =
                                          snapshotResearcher.data()
                                              as Map<String, dynamic>?;
                                      print('Researcher Data: $researcherData');
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SamplesScreen(
                                            labId: widget.sample.labId!,
                                            labName: labData["labName"],
                                            members: labData["members"] ?? [],
                                            researcherData: researcherData!,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    }

                                    // Exibe os detalhes da amostra
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (ctx) => SampleDetailsScreen(
                                    //       sample: widget.sample,
                                    //     ),
                                    //   ),
                                    // );
                                  }
                                } catch (e) {
                                  print(
                                      "Erro ao obter dados do laboratório: $e");
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 126, 217, 87),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save),
                                SizedBox(width: 8.0),
                                Text(
                                  'Save changes',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
