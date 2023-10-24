import 'package:flutter/material.dart';
import 'package:labtracking/models/new_researcher_form_data..dart';

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
  final _newResearcherFormData = NewResearcherFormData();

  bool isLoading = false;

  void submit() {
    setState(() {
      isLoading = true;
    });

    widget.onSubmit(_newResearcherFormData);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              key: const ValueKey('name'),
              initialValue: _newResearcherFormData.name,
              decoration: const InputDecoration(labelText: 'Name'),
              enabled: false,
            ),
            TextFormField(
              key: const ValueKey('email'),
              initialValue: _newResearcherFormData.email,
              decoration: const InputDecoration(labelText: 'E-mail'),
              enabled: false,
            ),
            TextFormField(
              key: const ValueKey('institution'),
              initialValue: _newResearcherFormData.email,
              decoration: const InputDecoration(labelText: 'Institution'),
              onChanged: (institution) =>
                  _newResearcherFormData.institution = institution,
              enabled: true,
            ),
            TextFormField(
              key: const ValueKey('address'),
              initialValue: _newResearcherFormData.email,
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (address) => _newResearcherFormData.address = address,
              enabled: true,
            ),
            TextFormField(
              key: const ValueKey('country'),
              initialValue: _newResearcherFormData.email,
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
