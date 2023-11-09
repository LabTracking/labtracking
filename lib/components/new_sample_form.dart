import 'package:flutter/material.dart';
import 'package:labtracking/models/gas.dart';
import 'package:labtracking/models/sediment.dart';
import 'package:labtracking/models/water.dart';
import 'package:labtracking/services/new_sample_service.dart';

class NewSampleForm extends StatefulWidget {
  const NewSampleForm({super.key});

  @override
  State<NewSampleForm> createState() => _NewSampleFormState();
}

class _NewSampleFormState extends State<NewSampleForm> {
  @override
  final _formKey = GlobalKey<FormState>();

  String newSample = '';
  final newSampleController = TextEditingController();

  bool isLoading = false;

  int? _value;

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
      await NewSampleService.save(Gas().name, newSampleController.text);
    }

    if (_value == 2) {
      await NewSampleService.save(Sediment().name, newSampleController.text);
    }

    if (_value == 3) {
      await NewSampleService.save(Water().name, newSampleController.text);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 126, 217, 87),
                    size: 35,
                  ),
                  Text(
                    "Add new sample",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                      shadows: [
                        Shadow(
                          color:
                              Colors.black12, // Choose the color of the shadow
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
            Column(
              children: [
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
                  value: 3,
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
              ],
            ),
            TextFormField(
              key: const ValueKey('name'),
              controller: newSampleController,
              onChanged: (type) => setState(() => newSample = type),
              enabled: true,
              decoration: const InputDecoration(
                labelText: 'Sample name (ex.: Curuai Lake)',
              ),
            ),
            const SizedBox(height: 5),
            isLoading == true
                ? const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 92, 225, 230),
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
        ),
      ),
    );
  }
}
