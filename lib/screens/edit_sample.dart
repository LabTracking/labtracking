import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/components/new_gas_sample_form.dart';
import 'package:labtracking/components/new_sediment_sample_form.dart';
import 'package:labtracking/components/new_water_sample_form.dart';
import 'package:labtracking/models/sample.dart';

class EditSample extends StatefulWidget {
  final Sample sample;
  const EditSample({required this.sample, super.key});

  @override
  State<EditSample> createState() => _EditSampleState();
}

class _EditSampleState extends State<EditSample> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController sampleNameController = TextEditingController();
  TextEditingController dateAnalysisController = TextEditingController();
  TextEditingController exitDateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController storageConditionController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController ecosystemController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();

  bool isLoading = false;
  bool sampleExistsChanged = false;

  //storageTemperature variables
  List<Map<String, String>> storageTemperature = [];
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

  @override
  void initState() {
    super.initState();

    // Pre-fill form fields with Sample values
    sampleNameController.text = widget.sample.name ?? '';
    dateAnalysisController.text = widget.sample.date ?? '';
    exitDateController.text = widget.sample.exitDate ?? '';
    locationController.text = widget.sample.location ?? '';
    storageConditionController.text = widget.sample.storageCondition ?? '';
    observationController.text = widget.sample.observation ?? '';
    ecosystemController.text = widget.sample.ecosystem ?? '';
    entryDateController.text = widget.sample.entryDate ?? '';
    sampleExistsChanged = widget.sample.exists ?? true;

    // Ensure `storageTemperature` is correctly typed and initialized
    if (widget.sample.storageTemperature != null &&
        widget.sample.storageTemperature!.isNotEmpty) {
      storageTemperature =
          List<Map<String, String>>.from(widget.sample.storageTemperature!);

      // Assuming the first item in storageTemperature is valid
      if (storageTemperature.isNotEmpty) {
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
    storageConditionController.dispose();
    observationController.dispose();
    ecosystemController.dispose();
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
    return Scaffold(
      appBar: LabTrackingBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Color.fromARGB(255, 126, 217, 87)),
                    Text(
                      "Edit sample",
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
                                        title: const Text("Yes"),
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
                          TextFormField(
                            key: const ValueKey('entryDate'),
                            controller: entryDateController,
                            decoration: InputDecoration(
                              hintText: 'Entry date (dd/mm/yyyy)',
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
                          TextFormField(
                            key: const ValueKey('exitDate'),
                            controller: exitDateController,
                            decoration: InputDecoration(
                              hintText: 'Exit date (dd/mm/yyyy)',
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
                          TextFormField(
                            key: const ValueKey('location'),
                            controller: locationController,
                            decoration: InputDecoration(
                              hintText: 'Location',
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
                          TextFormField(
                            key: const ValueKey('ecosystem'),
                            controller: ecosystemController,
                            decoration: InputDecoration(
                              hintText: 'Ecosystem',
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
                          TextFormField(
                            key: const ValueKey('storageCondition'),
                            controller: storageConditionController,
                            decoration: InputDecoration(
                              hintText: 'Storage condition',
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
                          TextFormField(
                            key: const ValueKey('dateAnalysis'),
                            controller: dateAnalysisController,
                            decoration: InputDecoration(
                              hintText: 'Date of analysis (dd/mm/yyyy)',
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
                          TextFormField(
                            key: const ValueKey('observation'),
                            controller: observationController,
                            decoration: InputDecoration(
                              hintText: 'Observations',
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
                          ElevatedButton(
                            onPressed: _addAnalysisFields,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  const Color.fromARGB(255, 126, 217, 87),
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveAnalysis();

                                // Save the Sample object and other fields
                                // Do whatever action you need here
                                Navigator.pop(context);
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
                                Text('Save Changes')
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
