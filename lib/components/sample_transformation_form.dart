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

class SampleTransformationForm extends StatefulWidget {
  final String researcherId;
  final String researcherEmail;
  final String labId;
  final String sampleType;
  final double lat;
  final double long;
  final String previousSample;

  const SampleTransformationForm({
    required this.researcherId,
    required this.researcherEmail,
    required this.labId,
    required this.sampleType,
    required this.lat,
    required this.long,
    required this.previousSample,
    super.key,
  });

  @override
  State<SampleTransformationForm> createState() =>
      _SampleTransformationFormState();
}

class _SampleTransformationFormState extends State<SampleTransformationForm> {
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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final newGasSampleForm = NewGasSampleForm(widget.labId, true);
    final newWaterSampleForm = NewWaterSampleForm(widget.labId, true);
    final newSedimentSampleForm = NewSedimentSampleForm(widget.labId, true);
    final newOrganismPartsSampleForm =
        NewOrganismPartsSample(widget.labId, true);
    void submit() async {
      setState(() {
        isLoading = true;
      });

      // if (widget.email == null) {
      //   return;
      // }

      if (widget.sampleType == null) {
        return;
      }

      if (widget.sampleType == "gas") {
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
            widget.lat,
            widget.long,
            newGasSampleForm.previousSample);
      }

      if (widget.sampleType == "sediment") {
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
            widget.lat,
            widget.long,
            newSedimentSampleForm.previousSample);
      }

      if (widget.sampleType == "water") {
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
            newGasSampleForm.gasType,
            newGasSampleForm.co2,
            newGasSampleForm.ch4,
            newGasSampleForm.no2,
            widget.lat,
            widget.long,
            newWaterSampleForm.previousSample);
      }

      if (widget.sampleType == "organism parts") {
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
            ecosystemController.text,
            widget.lat,
            widget.long,
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
                    if (widget.sampleType == "gas") newGasSampleForm,
                    if (widget.sampleType == "sediment") newSedimentSampleForm,
                    if (widget.sampleType == "water") newWaterSampleForm,
                    if (widget.sampleType == "organism parts")
                      newOrganismPartsSampleForm,
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
