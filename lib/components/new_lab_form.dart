import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewLabForm extends StatefulWidget {
  final void Function(String, List<String>, String?, List<String>) onSubmit;
  final String? createdBy;

  const NewLabForm(this.onSubmit, this.createdBy);

  @override
  State<NewLabForm> createState() => _NewLabFormState();
}

class _NewLabFormState extends State<NewLabForm> {
  final _nameController = TextEditingController();
  List<String> members = [];
  List<bool> checked = [];
  List<Widget> list = [];
  List<String> leaders = [];
  final _searchController = TextEditingController();
  bool isLoading = false;
  String? _emailError;

  getTextWidgets() {
    list = [];

    for (var i = 0; i < members.length; i++) {
      checked.add(false);
      list.add(
        TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                members[i].isNotEmpty ? members[i].toString() : "",
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: Colors.grey,
                    tristate: false,
                    value: checked[i],
                    onChanged: (bool? value) {
                      setState(() {
                        checked[i] = value!;
                      });
                    },
                  ),
                  const Text(
                    "Leader?",
                    style: TextStyle(color: Colors.black38),
                  ),
                ],
              ),
            ],
          ),
          onPressed: () {
            setState(() {
              members.removeAt(i);
              checked.removeAt(i);
            });
          },
        ),
      );
    }

    return SingleChildScrollView(child: Column(children: list));
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@(gmail\.com|id\.uff\.br)$");
    return emailRegex.hasMatch(email);
  }

  _submitForm() async {
    final name = _nameController.text;
    String leader = widget.createdBy!;
    if (leader.isEmpty || name.isEmpty || name.length <= 3) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Lab name must have more than 3 chars.'),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 126, 217, 87),
                ),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      isLoading = true;
    });

    for (int i = 0; i < members.length; i++) {
      if (checked[i] == true) {
        leaders.add(members[i]);
      }
    }
    leaders.add(widget.createdBy!);
    members.add(widget.createdBy!);

    widget.onSubmit(name, leaders, widget.createdBy, members);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Laboratory added'),
      duration: Duration(seconds: 2),
    ));
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  onSubmitted: (_) => _submitForm(),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Laboratory name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                        TextFormField(
                          controller: _searchController,
                          onChanged: (value) {
                            _searchController.text = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Member e-mails',
                            errorText: _emailError,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              String email = _searchController.text;
                              if (email.isNotEmpty) {
                                if (_validateEmail(email)) {
                                  members.add(email);
                                  _searchController.clear();
                                  _emailError = null;
                                  _updateEmailStream('');
                                } else {
                                  _emailError =
                                      "Invalid email. Only Gmail or id.uff.br are allowed.";
                                }
                              } else {
                                _emailError = "Email field is empty.";
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
                      backgroundColor: const Color.fromARGB(255, 126, 217, 87),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:dropdown_search/dropdown_search.dart';

// class NewLabForm extends StatefulWidget {
//   final void Function(String, List<String>, String?, List<String>) onSubmit;
//   final String? createdBy;

//   const NewLabForm(this.onSubmit, this.createdBy);

//   @override
//   State<NewLabForm> createState() => _NewLabFormState();
// }

// class _NewLabFormState extends State<NewLabForm> {
//   //final _idController = TextEditingController();
//   final _nameController = TextEditingController();
//   //final _leaderController = TextEditingController();
//   List<String> members = [];
//   List<bool> checked = [];
//   List<Widget> list = [];
//   List<String> leaders = [];
//   //final _membersController = TextEditingController();
//   final _searchController = TextEditingController();
//   //final _searchTerm = '';
//   bool isLoading = false;
//   //bool isChecked = false;

//   getTextWidgets() {
//     list = [];

//     for (var i = 0; i < members.length; i++) {
//       checked.add(false);
//       list.add(
//         TextButton(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 members[i].isNotEmpty ? members[i].toString() : "",
//                 style: const TextStyle(
//                   color: Colors.blue,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Checkbox(
//                     activeColor: Colors.grey,
//                     tristate: false,
//                     value: checked[i],
//                     onChanged: (bool? value) {
//                       setState(() {
//                         checked[i] = value!;
//                       });
//                     },
//                   ),
//                   const Text(
//                     "Leader?",
//                     style: TextStyle(color: Colors.black38),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           onPressed: () {
//             setState(() {
//               members.removeAt(i);
//               checked.removeAt(i);
//             });
//           },
//         ),
//       );
//     }

//     // members.asMap().forEach(
//     //   (element) {
//     //     list.add(
//     //       TextButton(
//     //         child: Text(
//     //           element.isNotEmpty ? element.toString() : "",
//     //           style: TextStyle(
//     //             color: Colors.blue,
//     //           ),
//     //         ),
//     //         onPressed: () {},
//     //       ),
//     //     );
//     //   },

//     return SingleChildScrollView(child: Column(children: list));
//   }

//   _submitForm() async {
//     //final id = int.parse(_idController.text);
//     final name = _nameController.text;
//     //final leader = _leaderController.text;
//     String leader = widget.createdBy!;
//     if (leader.isEmpty || name.isEmpty) {
//       showDialog<void>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: const SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   Text('Lab name must have more than 3 chars.'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               ElevatedButton(
//                 child: const Text(
//                   'OK',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 126, 217, 87),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//     setState(() {
//       isLoading = true;
//     });

//     print("HERE:     $leader");

//     for (int i = 0; i < members.length; i++) {
//       if (checked[i] == true) {
//         leaders.add(members[i]);
//       }
//     }
//     leaders.add(widget.createdBy!);
//     members.add(widget.createdBy!);

//     widget.onSubmit(name, leaders, widget.createdBy, members);
//     setState(() {
//       isLoading = false;
//     });
//     Navigator.of(context).pop();
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('Laboratory added'),
//       duration: Duration(seconds: 2),
//     ));
//   }

//   Stream<QuerySnapshot>? _emailStream;

//   @override
//   void initState() {
//     super.initState();
//     _emailStream =
//         FirebaseFirestore.instance.collection('researchers').snapshots();
//   }

//   void _updateEmailStream(String searchTerm) {
//     setState(() {
//       _emailStream = FirebaseFirestore.instance
//           .collection('researchers')
//           .where('email', isGreaterThanOrEqualTo: searchTerm)
//           .where('email', isLessThan: searchTerm + 'z')
//           .snapshots();
//     });
//   }

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Card(
//         //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
//         elevation: 5,
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 // TextField(
//                 //   keyboardType: TextInputType.text,
//                 //   onSubmitted: (_) => _submitForm(),
//                 //   controller: _idController,
//                 //   decoration: InputDecoration(labelText: "ID"),
//                 // ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextField(
//                   keyboardType: TextInputType.text,
//                   onSubmitted: (_) => _submitForm(),
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: "Labratory name",
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey, width: 0.0),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 // TextField(
//                 //   keyboardType: TextInputType.text,
//                 //   onSubmitted: (_) => _submitForm(),
//                 //   controller: _leaderController,
//                 //   decoration: InputDecoration(
//                 //     labelText: "Leader",
//                 //     enabledBorder: const OutlineInputBorder(
//                 //       borderSide:
//                 //           const BorderSide(color: Colors.grey, width: 0.0),
//                 //     ),
//                 //   ),
//                 // ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black26),
//                       borderRadius: BorderRadius.circular(5)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         TextField(
//                           controller: _searchController,
//                           onChanged: (value) {
//                             //_updateEmailStream(value);
//                             _searchController.text = value;
//                           },
//                           decoration: const InputDecoration(
//                             labelText: 'Member e-mails',
//                           ),
//                         ),
//                         // StreamBuilder<QuerySnapshot>(
//                         //   stream: _emailStream,
//                         //   builder: (context, snapshot) {
//                         //     if (snapshot.connectionState ==
//                         //         ConnectionState.waiting) {
//                         //       return CircularProgressIndicator();
//                         //     }
//                         //     if (snapshot.hasError) {
//                         //       return Text('Error: ${snapshot.error}');
//                         //     }
//                         //     List<String> emails = snapshot.data!.docs
//                         //         .map((doc) => doc['email'] as String)
//                         //         .toList();
//                         //     return DropdownSearch<String>(
//                         //       popupProps: PopupProps.menu(
//                         //         showSelectedItems: true,
//                         //         //disabledItemFn: (String s) => s.startsWith('I'),
//                         //       ),
//                         //       dropdownDecoratorProps: DropDownDecoratorProps(
//                         //         dropdownSearchDecoration: InputDecoration(
//                         //           labelText: "Member e-mails",
//                         //           //hintText: "country in menu mode",
//                         //         ),
//                         //       ),
//                         //       items: emails,

//                         //       //label: "Select Email",
//                         //       //hint: "Select Email",
//                         //       onChanged: (String? value) {
//                         //         // Do something with the selected email
//                         //         setState(() {
//                         //           _searchController.text = value!;
//                         //         });
//                         //       },
//                         //     );
//                         //   },
//                         // ),
//                         TextButton(
//                           onPressed: () {
//                             setState(() {
//                               if (_searchController.text.length > 0) {
//                                 setState(() {
//                                   members.add(_searchController.text);
//                                 });
//                                 _searchController.clear();
//                                 _updateEmailStream('');
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("Text is empty"),
//                                   ),
//                                 );
//                               }
//                             });
//                           },
//                           child: const Text("Add member"),
//                         ),
//                         getTextWidgets(),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     onPressed: _submitForm,
//                     child: isLoading == true
//                         ? CircularProgressIndicator(
//                             backgroundColor: Color.fromARGB(255, 92, 225, 230),
//                           )
//                         : Text(
//                             "Create laboratory",
//                             style: TextStyle(
//                                 fontFamily: 'Roboto', color: Colors.white),
//                           ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 126, 217, 87),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
