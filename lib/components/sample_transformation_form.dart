import 'dart:math';
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

  final dateController = TextEditingController();
  final dateAnalysisController = TextEditingController();
  final entryDateController = TextEditingController();
  final exitDateController = TextEditingController();
  final locationController = TextEditingController();
  final historyController = TextEditingController();
  final observationController = TextEditingController();

  bool isLoading = false;

  bool sampleExistsChanged = false; // Default value is false

  // Future<DocumentSnapshot<Map<String, dynamic>>> fetchSample(String sampleId,
  //     {Map<String, dynamic>? updateData}) async {
  //   final DocumentReference<Map<String, dynamic>> docRef =
  //       FirebaseFirestore.instance.collection('samples').doc(sampleId);

  //   if (updateData != null) {
  //     await docRef.update(updateData);
  //   }

  //   DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();

  //   if (snapshot.exists) {
  //     return snapshot;
  //   } else {
  //     throw Exception('Sample not found');
  //   }
  // }

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
    final newOrganismPartsSampleForm =
        NewOrganismPartsSample(widget.sample.labId!, true);

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
          date: dateController.text,
          entryDate: entryDateController.text,
          exitDate: exitDateController.text,
          location: locationController.text,
          storageCondition: historyController.text,
          observation: observationController.text,
          ecosystem: widget.sample.ecosystem!,
          gasType: newGasSampleForm.gasType,
          chamberType: newGasSampleForm.chamberType,
          co2: newGasSampleForm.co2,
          ch4: newGasSampleForm.ch4,
          no2: newGasSampleForm.no2,
          latitude: widget.sample.latitude,
          longitude: widget.sample.longitude,
          samples: [],
          level: widget.sample.level != null ? widget.sample.level! + 1 : 1,
          id: "${widget.sample.id}${DateTime.timestamp().millisecondsSinceEpoch}",
          fatherId: widget.sample.id,
          originalSampleId: widget.sample.originalSampleId ?? widget.sample.id,
          exists: true,
        );

        // if (sampleExistsChanged == true) {
        //   var originalSampleDoc = await FirebaseFirestore.instance
        //       .collection('samples')
        //       .doc(newSample.originalSampleId)
        //       .get();

        //   if (originalSampleDoc.exists) {
        //     List<dynamic> existingSamples =
        //         originalSampleDoc.data()!['samples'];

        //     if (widget.sample.id == originalSampleDoc.id) {
        //       await originalSampleDoc.reference.update({
        //         //'samples': FieldValue.arrayUnion([newSample.toMap()])
        //         'exists': !sampleExistsChanged
        //       });
        //     } else {
        //       bool found = await _findSample(existingSamples, newSample);

        //       if (found) {
        //         await originalSampleDoc.reference
        //             .update({'exists': !sampleExistsChanged});
        //       } else {
        //         print(
        //             "Error: Sample with ID ${widget.sample.id} not found in original sample.");
        //       }
        //     }
        //   }
        // }
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

      // if (widget.sampleType == "sediment") {
      //   final newId = await NewSampleService.saveSediment(
      //       false,
      //       Sediment().name,
      //       widget.researcherId,
      //       widget.researcherEmail,
      //       widget.labId,
      //       dateController.text,
      //       entryDateController.text,
      //       exitDateController.text,
      //       locationController.text,
      //       historyController.text,
      //       observationController.text,
      //       widget.ecosystem,
      //       newSedimentSampleForm.remineralization ?? '',
      //       newSedimentSampleForm.co2,
      //       newSedimentSampleForm.ch4,
      //       newSedimentSampleForm.no2,
      //       newSedimentSampleForm.sand,
      //       newSedimentSampleForm.silt,
      //       newSedimentSampleForm.clay,
      //       newSedimentSampleForm.n,
      //       newSedimentSampleForm.delta13c,
      //       newSedimentSampleForm.delta15n,
      //       newSedimentSampleForm.density,
      //       widget.lat,
      //       widget.long,
      //       widget.previousSample);
      //   await fetchSample(widget.previousSample,
      //       updateData: {"nextSample": newId});
      // }

      // if (widget.sampleType == "water") {
      //   final newId = await NewSampleService.saveWater(
      //       false,
      //       Water().name,
      //       widget.researcherId,
      //       widget.researcherEmail,
      //       widget.labId,
      //       dateController.text,
      //       entryDateController.text,
      //       exitDateController.text,
      //       locationController.text,
      //       historyController.text,
      //       observationController.text,
      //       widget.ecosystem,
      //       newWaterSampleForm.waterType ?? '',
      //       newWaterSampleForm.co2,
      //       newWaterSampleForm.ch4,
      //       newWaterSampleForm.no2,
      //       widget.lat,
      //       widget.long,
      //       widget.previousSample);

      //   await fetchSample(widget.previousSample,
      //       updateData: {"nextSample": newId});
      // }

      // if (widget.sampleType == "organism parts") {
      //   final newId = await NewSampleService.save(
      //       OrganismParts().name,
      //       widget.researcherId,
      //       widget.researcherEmail,
      //       widget.labId,
      //       dateController.text,
      //       entryDateController.text,
      //       exitDateController.text,
      //       locationController.text,
      //       historyController.text,
      //       observationController.text,
      //       widget.ecosystem,
      //       widget.lat,
      //       widget.long,
      //       widget.previousSample);
      //   await fetchSample(widget.previousSample,
      //       updateData: {"nextSample": newId});
      // }

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
                  children: [
                    const Text('Does the parent sample still exist?'),
                    Row(
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
                    if (widget.sample.sampleType == "gas") newGasSampleForm,
                    if (widget.sample.sampleType == "sediment")
                      newSedimentSampleForm,
                    if (widget.sample.sampleType == "water") newWaterSampleForm,
                    if (widget.sample.sampleType == "organism parts")
                      newOrganismPartsSampleForm,
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
