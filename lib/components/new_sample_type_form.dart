import 'package:flutter/material.dart';
import 'package:labtracking/services/new_sample_type_service.dart';

class NewSampleTypeForm extends StatefulWidget {
  String? email;

  NewSampleTypeForm({
    Key? key,
    required this.email,
  });

  @override
  State<NewSampleTypeForm> createState() => _NewSampleTypeFormState();
}

class _NewSampleTypeFormState extends State<NewSampleTypeForm> {
  final _formKey = GlobalKey<FormState>();

  String newSampleType = '';
  final newSampleTypeController = TextEditingController();

  bool isLoading = false;

  void submit() async {
    setState(() {
      isLoading = true;
    });

    if (widget.email == null) {
      return;
    }
    await NewSampleTypeService.save(newSampleType, widget.email!);

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
                    "New sample type",
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
            TextFormField(
              key: const ValueKey('name'),
              controller: newSampleTypeController,
              onChanged: (type) => setState(() => newSampleType = type),
              enabled: true,
              decoration: const InputDecoration(
                labelText: 'New sample type (ex.: sediment)',
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
