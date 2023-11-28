import 'package:flutter/material.dart';

class SampleItem extends StatelessWidget {
  final String type;
  final String date;
  const SampleItem({required this.type, required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    if (type == 'gas') {
      return ListTile(
        trailing: ElevatedButton(onPressed: null, child: Text("Details")),
        title: Text(
          'Gas',
          style: TextStyle(color: Color(0xFF6200EE)),
        ),
        subtitle: Text('$date'),
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
      return ListTile(
        trailing: ElevatedButton(onPressed: null, child: Text("Details")),
        title: Text(
          'Sediment',
          style: TextStyle(color: Colors.orange),
        ),
        subtitle: Text('$date'),
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.work,
            color: Colors.orange,
          ),
        ),
      );
    }

    if (type == 'water') {
      return ListTile(
        trailing: ElevatedButton(onPressed: null, child: Text("Details")),
        title: Text(
          'Water',
          style: TextStyle(color: Colors.lightBlue),
        ),
        subtitle: Text('$date'),
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.work,
            color: Colors.lightBlue,
          ),
        ),
      );
    }
    return ListTile(
      trailing: ElevatedButton(onPressed: null, child: Text("Details")),
      title: Text(
        'Organism parts',
        style: TextStyle(color: Colors.green),
      ),
      subtitle: Text('$date'),
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 241, 244, 246),
        child: Icon(
          Icons.work,
          color: Colors.green,
        ),
      ),
    );
  }
}
