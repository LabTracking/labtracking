import 'package:flutter/material.dart';
import 'package:labtracking/components/lab_tracking_bar.dart';

class EditSample extends StatefulWidget {
  const EditSample({super.key});

  @override
  State<EditSample> createState() => _EditSampleState();
}

class _EditSampleState extends State<EditSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LabTrackingBar(),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: double.infinity,
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business,
                  color: Color.fromARGB(255, 126, 217, 87),
                ),
                Text(
                  "Edit sample",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
            Text("OK")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {
          //_openNewSubjectFormModal(context);
        },
        backgroundColor: const Color.fromARGB(255, 126, 217, 87),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
