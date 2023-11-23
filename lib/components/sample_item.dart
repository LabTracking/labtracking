import 'package:flutter/material.dart';

class SampleItem extends StatelessWidget {
  final String type;
  const SampleItem({required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    if (type == 'gas') {
      return const ListTile(
        trailing: ElevatedButton(onPressed: null, child: Text("Details")),
        title: Text(
          'Gas',
          style: TextStyle(color: Color(0xFF6200EE)),
        ),
        subtitle: Text('Gas sample description'),
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.work,
            color: Color(0xFF6200EE),
          ),
        ),
      );
    }
    if (type == 'sediment') {
      return const ListTile(
        trailing: ElevatedButton(onPressed: null, child: Text("Details")),
        title: Text(
          'Sediment',
          style: TextStyle(color: Colors.orange),
        ),
        subtitle: Text('Gas sample description'),
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.work,
            color: Colors.orange,
          ),
        ),
      );
    }
    return const ListTile(
      trailing: ElevatedButton(onPressed: null, child: Text("Details")),
      title: Text(
        'Water',
        style: TextStyle(color: Colors.lightBlue),
      ),
      subtitle: Text('Water sample description'),
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 241, 244, 246),
        child: Icon(
          Icons.work,
          color: Colors.lightBlue,
        ),
      ),
    );
  }
}
