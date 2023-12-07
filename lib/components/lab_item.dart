import 'package:flutter/material.dart';

class LabItem extends StatelessWidget {
  final String labName;
  final String leaderName;
  const LabItem({required this.labName, required this.leaderName, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: const ElevatedButton(onPressed: null, child: Text("Details")),
      title: Text(labName, style: const TextStyle(color: Colors.green)),
      subtitle: Text(leaderName),
      leading: const CircleAvatar(
        backgroundColor: Color.fromARGB(255, 241, 244, 246),
        child: Icon(
          Icons.science,
          color: Colors.green,
        ),
      ),
    );
  }
}
