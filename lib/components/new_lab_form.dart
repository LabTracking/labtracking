import 'package:flutter/material.dart';

class NewLabForm extends StatefulWidget {
  final void Function(String, String, String?, List<String>) onSubmit;
  final String? createdBy;

  const NewLabForm(this.onSubmit, this.createdBy);

  @override
  State<NewLabForm> createState() => _NewLabFormState();
}

class _NewLabFormState extends State<NewLabForm> {
  //final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _leaderController = TextEditingController();
  List<String> members = [];
  List<Widget> list = [];
  final _membersController = TextEditingController();
  bool isLoading = false;

  getTextWidgets() {
    list = [];

    for (var i = 0; i < members.length; i++) {
      list.add(
        TextButton(
          child: Text(
            members[i].isNotEmpty ? members[i].toString() : "",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          onPressed: () {
            setState(() {
              members.removeAt(i);
            });
          },
        ),
      );
    }

    // members.asMap().forEach(
    //   (element) {
    //     list.add(
    //       TextButton(
    //         child: Text(
    //           element.isNotEmpty ? element.toString() : "",
    //           style: TextStyle(
    //             color: Colors.blue,
    //           ),
    //         ),
    //         onPressed: () {},
    //       ),
    //     );
    //   },

    return SingleChildScrollView(child: Column(children: list));
  }

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

    widget.onSubmit(name, leader, widget.createdBy, members);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
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
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _submitForm(),
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Labratory name",
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _submitForm(),
                controller: _leaderController,
                decoration: InputDecoration(
                  labelText: "Leader",
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _membersController,
                      decoration: InputDecoration(
                        labelText: "Member e-mail",
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (_membersController.text.length > 0) {
                            members.add(_membersController.text);
                            _membersController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Text is empty"),
                              ),
                            );
                          }
                        });
                      },
                      child: const Text("Add member"),
                    ),
                    getTextWidgets(),
                  ],
                ),
              ),

              const SizedBox(
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
                          style: TextStyle(
                              fontFamily: 'Roboto', color: Colors.white),
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
