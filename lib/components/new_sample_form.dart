import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labtracking/components/location_input.dart';
import 'package:labtracking/components/new_gas_sample_form.dart';
import 'package:labtracking/components/new_sediment_sample_form.dart';
import 'package:labtracking/components/new_water_sample_form.dart';
import 'package:labtracking/services/sample_service.dart';

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

  final sampleNameController = TextEditingController();
  final providerController = TextEditingController();
  final weightController = TextEditingController();
  final dateController = TextEditingController();

  final dateAnalysisController = TextEditingController(); //fica vazio
  final exitDateController = TextEditingController(); //fica vazio

  final locationController = TextEditingController();
  //final storageConditionController = TextEditingController();
  String storageConditionText = "Other";

  final observationController = TextEditingController();
  //final ecosystemController = TextEditingController();

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
    return null;
  }

  IconData _getIconDataForValue(int? value) {
    switch (value) {
      case 1:
        return Icons.air;
      case 2:
        return Icons.terrain;
      case 3:
      case 4:
        return Icons.water;
      default:
        return Icons.science;
    }
  }

  Color _getColorForValue(int? value) {
    switch (value) {
      case 1:
        return Color(0xFF6200EE);
      case 2:
        return Colors.orange;
      case 3:
      case 4:
        return Colors.lightBlue;
      default:
        return Color.fromARGB(255, 126, 217, 87);
    }
  }

  final LocationInput locationInput = LocationInput();

  @override
  Widget build(BuildContext context) {
    final newGasSampleForm = NewGasSampleForm(widget.labId, false);
    final newWaterSampleForm = NewWaterSampleForm(widget.labId, false);
    final newSedimentSampleForm = NewSedimentSampleForm(widget.labId, false);

    Future<void> selectDate(
      BuildContext context,
      double? lat,
      double? long,
      String? sampleName,
      String? providerName,
      String? weight,
      List<Map<String, String>>? storageTemperatureList,
      String? ecosystem,
      String? location,
      String? storageCondition,
      String? observation,
    ) async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (selectedDate != null) {
        setState(
          () {
            dateController.text =
                selectedDate.toLocal().toString().split(' ')[0].toString();

            locationInput.point?.lat = lat;

            locationInput.point?.long = long;

            sampleNameController.text = sampleName ?? "";

            providerController.text = providerName ?? "";

            weightController.text = weight ?? "";

            storageTemperature = storageTemperatureList ?? [];

            _selectedOption = ecosystem;

            locationController.text = location ?? "";

            if (_value == 1) {
              newGasSampleForm.storageCondition = storageCondition;
              storageConditionText =
                  newGasSampleForm.storageCondition ?? "Other";
            }

            if (_value == 2) {
              newSedimentSampleForm.storageCondition = storageCondition;
              storageConditionText =
                  newGasSampleForm.storageCondition ?? "Other";
            }

            if (_value == 3) {
              newWaterSampleForm.storageCondition = storageCondition;
              storageConditionText =
                  newGasSampleForm.storageCondition ?? "Other";
            }
          },
        );
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
          checkin,
          "gas",
          widget.researcherId,
          widget.researcherEmail,
          widget.labId,
          dateController.text,
          DateTime.now().toString(), //entryDateController.text,
          exitDateController.text,
          locationController.text,
          storageConditionText, // newGasSampleForm.storageCondition ??
          //     "Other", //storageConditionController.text,
          observationController.text,
          _selectedOption ?? '',

          locationInput.point?.lat!,
          locationInput.point?.long,
          0,
          sampleNameController.text,
          providerController.text,
          weightController.text,
          storageTemperature,
          [], //analysis

          [], //samples
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
          DateTime.now().toString(), //entryDateController.text,
          exitDateController.text,
          locationController.text,
          storageConditionText, // newSedimentSampleForm.storageCondition ??
          //     "Other", //storageConditionController.text,
          observationController.text,
          _selectedOption ?? '',

          locationInput.point?.lat!,
          locationInput.point?.long!,
          0,
          sampleNameController.text,
          providerController.text,
          weightController.text,
          storageTemperature,
          [], //analysis
          [], //samples
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
          DateTime.now().toString(), //entryDateController.text,
          exitDateController.text,
          locationController.text,
          storageConditionText, // newWaterSampleForm.storageCondition ??
          //     "Other", //storageConditionController.text,
          observationController.text,
          _selectedOption ?? '',

          locationInput.point?.lat!,
          locationInput.point?.long!,
          0,
          sampleNameController.text,
          providerController.text,
          weightController.text,
          storageTemperature,
          [], //analysis
          [], //samples
        );
      }

      if (_value == 4) {
        // await NewSampleService.save(
        //     OrganismParts().name,
        //     widget.researcherId,
        //     widget.researcherEmail,
        //     widget.labId,
        //     dateController.text,
        //     DateTime.now(),
        //     exitDateController.text,
        //     locationController.text,
        //     storageConditionController.text,
        //     observationController.text,
        //     ecosystemController.text.toString(),
        //     locationInput.point?.lat,
        //     locationInput.point?.long,
        //     newOrganismPartsSampleForm.previousSample);
      }

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();
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
                        _getIconDataForValue(_value),
                        color: _getColorForValue(_value),
                        size: 30,
                      ),
                      const Text(
                        " Sample check-in",
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
                FittedBox(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FittedBox(
                          child: Text("Matrix:",
                              style: TextStyle(color: Colors.grey)),
                        ),
                        FittedBox(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: const Color(0xFF6200EE),
                                  value: 1,
                                  groupValue: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  },
                                ),
                                const Text("Gas"),
                              ],
                            ),
                          ),
                        ),

                        FittedBox(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.orange,
                                value: 2,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                              ),
                              const Text("Soil/sediment"),
                            ],
                          ),
                        ),

                        FittedBox(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.lightBlue,
                                value: 3,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                              ),
                              const Text("Water"),
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
                          ),
                          filled: true,
                          fillColor:
                              Colors.black12, // Fill color set to transparent
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
                        key: const ValueKey('provider'),
                        controller: providerController,
                        onChanged: (type) =>
                            setState(() => providerController.text = type),
                        enabled: true,
                        decoration: InputDecoration(
                          hintText: 'Sample provider e-mail',
                          labelText: 'Sample provider e-mail *',
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
                          final emailPattern =
                              r'^[a-zA-Z0-9._%+-]+@(gmail\.com|id\.uff\.br)$';
                          final regex = RegExp(emailPattern);
                          if (value == null || value.isEmpty) {
                            return 'Provider e-mail is required';
                          } else if (!regex.hasMatch(value)) {
                            return 'Please enter a valid e-mail (gmail or id.uff.br)';
                          }
                          return null; // Return null if validation passes
                        },
                      ),

                      const SizedBox(height: 15),

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

                      const SizedBox(
                        height: 15,
                      ),

                      TextFormField(
                        key: const ValueKey("date"),
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: 'Sampling date',
                          labelText: 'Sampling date *',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          if (_value == 1) {
                            selectDate(
                              context,
                              locationInput.point?.lat,
                              locationInput.point?.long,
                              sampleNameController.text,
                              providerController.text,
                              weightController.text,
                              storageTemperature,
                              _selectedOption,
                              locationController.text,
                              newGasSampleForm.storageCondition,
                              observationController.text,
                            );
                          }
                          if (_value == 2) {
                            selectDate(
                              context,
                              locationInput.point?.lat,
                              locationInput.point?.long,
                              sampleNameController.text,
                              providerController.text,
                              weightController.text,
                              storageTemperature,
                              _selectedOption,
                              locationController.text,
                              newSedimentSampleForm.storageCondition,
                              observationController.text,
                            );
                          }
                          if (_value == 3) {
                            selectDate(
                              context,
                              locationInput.point?.lat,
                              locationInput.point?.long,
                              sampleNameController.text,
                              providerController.text,
                              weightController.text,
                              storageTemperature,
                              _selectedOption,
                              locationController.text,
                              newWaterSampleForm.storageCondition,
                              observationController.text,
                            );
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Sampling date is required';
                          }
                          return null; // Return null if validation passes
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              key: const ValueKey('storageTemperature'),
                              decoration: InputDecoration(
                                hintText: 'Stor. temp.',
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

                                  storageTemperature.clear();

                                  storageTemperature.add({
                                    _selectedStorageTemperatureOption
                                            .toString():
                                        temperatureValueController.text
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                      DropdownButtonFormField<String>(
                        key: const ValueKey('ecosystem'),
                        decoration: InputDecoration(
                          hintText: 'Select an ecosystem',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor:
                              Colors.black12, // Fill color set to transparent
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
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
                          ),
                          filled: true,
                          fillColor:
                              Colors.black12, // Fill color set to transparent
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),

                      if (_value == 1) newGasSampleForm,
                      if (_value == 2) newSedimentSampleForm,
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
                          ),
                          filled: true,
                          fillColor:
                              Colors.black12, // Fill color set to transparent
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
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
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 126, 217, 87),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    submit();
                                  }
                                },
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
