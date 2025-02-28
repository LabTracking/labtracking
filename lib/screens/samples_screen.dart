import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';
import 'package:labtracking/components/samples_list.dart';
import 'package:labtracking/screens/new_sample_screen.dart';

class SamplesScreen extends StatefulWidget {
  final String labId;
  final String labName;
  final List<dynamic> members;
  final Map<String, dynamic> researcherData;
  const SamplesScreen({
    required this.labId,
    required this.labName,
    required this.members,
    required this.researcherData,
    super.key,
  });

  @override
  State<SamplesScreen> createState() => _SamplesScreenState();
}

class _SamplesScreenState extends State<SamplesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)!.settings.arguments ??
    //     <String, dynamic>{}) as Map;

    //final labName = arguments["labName"] as String;

    final labId = widget.labId;
    final labName = widget.labName;
    final members = widget.members;

    getTextWidgets(List<dynamic> strings) {
      List<Widget> list = [];
      for (var i = 0; i < strings.length; i++) {
        list.add(
          Card(
            child: ListTile(
              title: FittedBox(child: Text(strings[i])),
              leading: const Icon(Icons.person, color: Colors.blue),
            ),
          ),
        );
      }
      return list;
    }

    return Scaffold(
      appBar: LabTrackingBar(
        researcherData: widget.researcherData,
        showPopup: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Center(
          child: Column(
            children: [
              // Image.asset(
              //   'assets/images/logo.png',
              //   width: double.infinity,
              //   height: 200,
              // ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.business,
                    color: Colors.blue,
                  ),
                  Text(
                    " $labName",
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(
              //       Icons.person,
              //       color: Colors.grey,
              //     ),
              //     Text(" Members")
              //   ],
              // ),

              Scrollbar(
                child: Container(
                  height: 125,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 50.0, right: 50),
                    child: Column(
                      children: [
                        Column(children: getTextWidgets(members)),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 237, 221, 221),
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.data_saver_off,
                    color: Colors.green,
                  ),
                  Text(
                    " Registered samples",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SamplesList(
                labId: labId,
                researcherData: widget.researcherData,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.researcherData['type'] != 'observer') {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (ctx) => NewSampleScreen(
                        labId: labId,
                        researcherData: widget.researcherData,
                      )),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Access denied"),
                  content: Text("You are not allowed to perform this action"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        },
        backgroundColor: const Color.fromARGB(255, 126, 217, 87),
        child: const Icon(Icons.add),
      ),
    );
  }
}
