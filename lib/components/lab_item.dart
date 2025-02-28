import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/screens/samples_screen.dart';

class LabItem extends StatelessWidget {
  final String labName;
  final String leaderName;
  final String id;
  final List<dynamic> members;
  final Map<String, dynamic> researcherData;

  const LabItem({
    required this.id,
    required this.labName,
    required this.leaderName,
    required this.members,
    required this.researcherData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    User? user;
    void labDetails() {
      // Navigator.of(context).pushNamed(AppRoutes.SAMPLES, arguments: {
      //   'user': user,
      //   'auth': _auth,
      //   'google': _googleSignIn,
      //   'labName': labName,
      //   'labId': id,
      // });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SamplesScreen(
            labId: id,
            labName: labName,
            members: members,
            researcherData: researcherData,
          ),
        ),
      );
    }

    return ListTile(
      trailing: ElevatedButton(
        onPressed: labDetails,
        child: const Text(
          "Samples",
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.lightBlue //Color.fromARGB(255, 126, 217, 87),
            ),
      ),
      title: Text(labName, style: const TextStyle()),
      subtitle: Text(
        "Created by $leaderName",
        style: TextStyle(color: Colors.black54, fontSize: 10),
      ),
      leading: const CircleAvatar(
        backgroundColor: Color.fromARGB(255, 241, 244, 246),
        child: Icon(Icons.business, color: Colors.lightBlue),
      ),
    );
  }
}
