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
  const SamplesScreen({
    required this.labId,
    required this.labName,
    required this.members,
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
    final labId = widget.labId;
    final labName = widget.labName;
    final members = widget.members;

    getTextWidgets(List<dynamic> strings) {
      return strings.map((member) {
        bool isHovered = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: Card(
                color: isHovered ? Colors.blue.shade50 : Colors.white,
                child: ListTile(
                  title: Center(child: Text(member)),
                  leading: const Icon(Icons.person, color: Colors.blue),
                ),
              ),
            );
          },
        );
      }).toList();
    }

    return Scaffold(
      appBar: LabTrackingBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.business, color: Colors.blue),
                  Text(
                    " $labName",
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Scrollbar(
                child: Container(
                  height: 125,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: getTextWidgets(members),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(color: Color.fromARGB(255, 237, 221, 221)),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.data_saver_off, color: Colors.green),
                  Text(" Registered samples",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 5),
              SamplesList(labId: labId),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => NewSampleScreen(labId: labId)),
          );
        },
        backgroundColor: const Color.fromARGB(255, 126, 217, 87),
        child: const Icon(Icons.add),
      ),
    );
  }
}
