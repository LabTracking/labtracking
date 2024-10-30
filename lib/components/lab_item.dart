import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/screens/samples_screen.dart';

import 'package:labtracking/utils/routes.dart';

class LabItem extends StatefulWidget {
  final String labName;
  final String leaderName;
  final String id;
  final List<dynamic> members;

  const LabItem({
    required this.id,
    required this.labName,
    required this.leaderName,
    required this.members,
    Key? key,
  }) : super(key: key);

  @override
  State<LabItem> createState() => _LabItemState();
}

class _LabItemState extends State<LabItem> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isHovered = false;

  void _labDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SamplesScreen(
          labId: widget.id,
          labName: widget.labName,
          members: widget.members,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        child: ListTile(
          trailing: ElevatedButton(
            onPressed: _labDetails,
            child: const Text(
              "Samples",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
            ),
          ),
          title: Text(widget.labName, style: const TextStyle()),
          subtitle: Text(
            "Created by ${widget.leaderName}",
            style: TextStyle(color: Colors.black54, fontSize: 10),
          ),
          leading: const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 241, 244, 246),
            child: Icon(Icons.business, color: Colors.lightBlue),
          ),
        ),
      ),
    );
  }
}
