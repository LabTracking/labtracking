import 'package:flutter/material.dart';

class NewLabForm extends StatefulWidget {
  final void Function(String, String, String?) onSubmit;
  final String? createdBy;

  const NewLabForm(this.onSubmit, this.createdBy);

  @override
  State<NewLabForm> createState() => _NewLabFormState();
}

class _NewLabFormState extends State<NewLabForm> {
  //final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _leaderController = TextEditingController();
  bool isLoading = false;

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });
    //final id = int.parse(_idController.text);
    final name = _nameController.text;
    final leader = _leaderController.text;

    if (leader.isEmpty || name.isEmpty) {
      return;
    }

    widget.onSubmit(name, leader, widget.createdBy);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // TextField(
              //   keyboardType: TextInputType.text,
              //   onSubmitted: (_) => _submitForm(),
              //   controller: _idController,
              //   decoration: InputDecoration(labelText: "ID"),
              // ),
              TextField(
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _submitForm(),
                controller: _nameController,
                decoration: InputDecoration(labelText: "Labratory name"),
              ),
              TextField(
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _submitForm(),
                controller: _leaderController,
                decoration: InputDecoration(labelText: "Leader"),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: isLoading == true
                      ? CircularProgressIndicator(
                          backgroundColor: Color.fromARGB(255, 92, 225, 230),
                        )
                      : Text(
                          "Add",
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 126, 217, 87),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
