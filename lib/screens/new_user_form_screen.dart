import 'package:flutter/material.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/models/researcher.dart';
import 'package:labtracking/services/auth_service.dart';

class NewUserFormScreen extends StatefulWidget {
  @override
  _NewUserFormScreenState createState() => _NewUserFormScreenState();
}

class _NewUserFormScreenState extends State<NewUserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _institutionController = TextEditingController();

  String? _selectedOption;

  final List<String> _options = [
    'admin',
    'observer',
    'default user',
  ];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LabTrackingBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add,
                      color: Colors.green,
                    ),
                    Text(
                      " New user",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      key: const ValueKey('user'),
                      decoration: InputDecoration(
                        labelText: 'User category *',
                        hintText: 'Select an user category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      value: _selectedOption,
                      items: _options.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the user category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        labelText: 'Name *', filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        labelText: 'Email *', filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the email';
                        }
                        // Simple email validation
                        if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Institution Field
                    TextFormField(
                      controller: _institutionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        labelText: 'Institution *', filled: true,
                        fillColor:
                            Colors.black12, // Fill color set to transparent
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the institution';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit Button

                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 126, 217, 87),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  Researcher researcher = Researcher(
                                    name: _nameController.text,
                                    institution:
                                        _institutionController.text ?? "",
                                    email: _emailController.text,
                                    type: _selectedOption ?? "",
                                  );

                                  await AuthService.saveResearcher2(researcher);

                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //       content: Text('Processing Data')),
                                  // );

                                  setState(() {
                                    isLoading = false;
                                  });

                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
