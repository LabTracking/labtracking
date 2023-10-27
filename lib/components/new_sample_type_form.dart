import 'package:flutter/material.dart';
import 'package:labtracking/models/new_researcher_form_data.dart';
import 'package:provider/provider.dart';

class NewSampleTypeForm extends StatefulWidget {
  //final void Function(NewSampleTypeFormData) onSubmit;

  const NewSampleTypeForm({
    Key? key,
    //required this.onSubmit,
  });

  @override
  State<NewSampleTypeForm> createState() => _NewSampleTypeFormState();
}

class _NewSampleTypeFormState extends State<NewSampleTypeForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    void submit() {
      setState(() {
        isLoading = true;
      });

      //widget.onSubmit(_NewSampleTypeFormData);

      setState(() {
        isLoading = false;
      });
    }

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
              enabled: true,
              decoration: const InputDecoration(
                labelText: 'New sample type (ex.: sediment)',
              ),
            ),
            const SizedBox(height: 5),
            isLoading == true
                ? const CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 92, 225, 230),
                  )
                : ElevatedButton(
                    onPressed: submit,
                    child: const Text("Add"),
                  )
          ],
        ),
      ),
    );
  }
}
