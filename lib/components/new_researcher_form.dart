import 'package:flutter/material.dart';
import 'package:labtracking/models/new_researcher_form_data.dart';
import 'package:provider/provider.dart';

class NewResearcherForm extends StatefulWidget {
  final void Function(NewResearcherFormData) onSubmit;

  const NewResearcherForm({
    Key? key,
    required this.onSubmit,
  });

  @override
  State<NewResearcherForm> createState() => _NewResearcherFormState();
}

class _NewResearcherFormState extends State<NewResearcherForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _newResearcherFormData =
        Provider.of<NewResearcherFormData>(context, listen: false);
    void submit() {
      setState(() {
        isLoading = true;
      });

      widget.onSubmit(_newResearcherFormData);

      setState(() {
        isLoading = false;
      });
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            TextFormField(
              key: const ValueKey('name'),
              initialValue: _newResearcherFormData.name,
              enabled: false,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              key: const ValueKey('email'),
              initialValue: _newResearcherFormData.email,
              decoration: const InputDecoration(labelText: 'E-mail'),
              enabled: false,
            ),
            TextFormField(
              key: const ValueKey('institution'),
              decoration: const InputDecoration(labelText: 'Institution'),
              onChanged: (institution) =>
                  _newResearcherFormData.institution = institution,
              enabled: true,
            ),
            TextFormField(
              key: const ValueKey('address'),
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (address) => _newResearcherFormData.address = address,
              enabled: true,
            ),
            TextFormField(
              key: const ValueKey('country'),
              decoration: const InputDecoration(labelText: 'Country'),
              onChanged: (country) => _newResearcherFormData.country = country,
              enabled: true,
            ),
            const SizedBox(height: 5),
            isLoading == true
                ? const CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 92, 225, 230),
                  )
                : ElevatedButton(
                    onPressed: submit,
                    child: const Text("Submit"),
                  )
          ],
        ),
      ),
    );
  }
}
