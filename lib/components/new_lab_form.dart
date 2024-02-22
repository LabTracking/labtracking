import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dropdown_search/dropdown_search.dart';

class NewLabForm extends StatefulWidget {
  final void Function(String, List<String>, String?, List<String>) onSubmit;
  final String? createdBy;

  const NewLabForm(this.onSubmit, this.createdBy);

  @override
  State<NewLabForm> createState() => _NewLabFormState();
}

class _NewLabFormState extends State<NewLabForm> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //final _idController = TextEditingController();
  final _nameController = TextEditingController();
  //final _leaderController = TextEditingController();
  List<String> members = [];
  List<Widget> list = [];
  //final _membersController = TextEditingController();
  final _searchController = TextEditingController();
  //final _searchTerm = '';
  bool isLoading = false;

  getTextWidgets() {
    list = [];

    for (var i = 0; i < members.length; i++) {
      list.add(
        TextButton(
          child: Text(
            members[i].isNotEmpty ? members[i].toString() : "",
            style: const TextStyle(
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
    //final leader = _leaderController.text;
    final leader = _googleSignIn.currentUser!.id;
    //if (leader.isEmpty || name.isEmpty) {
    //  return;
    //}

    widget.onSubmit(name, [leader], widget.createdBy, members);
    setState(() {
      isLoading = false;
    });
  }

  Stream<QuerySnapshot>? _emailStream;

  @override
  void initState() {
    super.initState();
    _emailStream =
        FirebaseFirestore.instance.collection('researchers').snapshots();
  }

  void _updateEmailStream(String searchTerm) {
    setState(() {
      _emailStream = FirebaseFirestore.instance
          .collection('researchers')
          .where('email', isGreaterThanOrEqualTo: searchTerm)
          .where('email', isLessThan: searchTerm + 'z')
          .snapshots();
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
              // TextField(
              //   keyboardType: TextInputType.text,
              //   onSubmitted: (_) => _submitForm(),
              //   controller: _leaderController,
              //   decoration: InputDecoration(
              //     labelText: "Leader",
              //     enabledBorder: const OutlineInputBorder(
              //       borderSide:
              //           const BorderSide(color: Colors.grey, width: 0.0),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          _updateEmailStream(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'Search members',
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _emailStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          List<String> emails = snapshot.data!.docs
                              .map((doc) => doc['email'] as String)
                              .toList();
                          return DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              //disabledItemFn: (String s) => s.startsWith('I'),
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Member e-mails",
                                //hintText: "country in menu mode",
                              ),
                            ),
                            items: emails,

                            //label: "Select Email",
                            //hint: "Select Email",
                            onChanged: (String? value) {
                              // Do something with the selected email
                              setState(() {
                                _searchController.text = value!;
                              });
                            },
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (_searchController.text.length > 0) {
                              members.add(_searchController.text);
                              _searchController.clear();
                              _updateEmailStream('');
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
                          "Create laboratory",
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
