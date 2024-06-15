import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labtracking/utils/routes.dart';

class SampleItem extends StatelessWidget {
  final String type;
  final String date;
  final String user;
  final Map details;
  final String id;
  const SampleItem({
    required this.type,
    required this.date,
    required this.user,
    required this.details,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void openDetailScreen() {
      Navigator.of(context)
          .pushNamed(AppRoutes.SAMPLE_DETAILS, arguments: details);
    }

    if (type == 'gas') {
      return ListTile(
        trailing: ElevatedButton(
          onPressed: openDetailScreen,
          child: Text(
            "Details",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6200EE)),
        ),
        title: Text(
          'Gas',
          style: TextStyle(color: Color(0xFF6200EE)),
        ),
        subtitle: Text(
            'Added by ${user} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(date))}'),
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.science_outlined,
            color: Color(0xFF6200EE),
          ),
        ),
      );
    }
    if (type == 'sediment') {
      return ListTile(
        trailing: ElevatedButton(
          onPressed: openDetailScreen,
          child: Text(
            "Details",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
        title: Text(
          'Sediment',
          style: TextStyle(color: Colors.orange),
        ),
        subtitle: Text(
            'Added by ${user} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(date))}'),
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.science_outlined,
            color: Colors.orange,
          ),
        ),
      );
    }

    if (type == 'water') {
      return ListTile(
        trailing: ElevatedButton(
          onPressed: openDetailScreen,
          child: Text(
            "Details",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
        ),
        title: Text(
          'Water',
          style: TextStyle(color: Colors.lightBlue),
        ),
        subtitle: Text(
            'Added by ${user} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(date))}'),
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.science_outlined,
            color: Colors.lightBlue,
          ),
        ),
      );
    }
    return ListTile(
      trailing: ElevatedButton(
        onPressed: openDetailScreen,
        child: Text(
          "Details",
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      ),
      title: Text(
        'Organism parts',
        style: TextStyle(color: Colors.green),
      ),
      subtitle: Text('$date'),
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 241, 244, 246),
        child: Icon(
          Icons.science_outlined,
          color: Colors.green,
        ),
      ),
    );
  }
}
