import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/screens/sample_details_screen.dart';

class SampleItem extends StatelessWidget {
  final Sample sample;
  final Map<String, dynamic> researcherData;
  final Sample mainSample;
  const SampleItem({
    required this.sample,
    required this.researcherData,
    required this.mainSample,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void openDetailScreen() {
      // Navigator.of(context)
      //     .pushNamed(AppRoutes.SAMPLE_DETAILS, arguments: sample);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SampleDetailsScreen(
            researcherData: researcherData,
            sample: sample,
            mainSample: mainSample,
          ),
        ),
      );
    }

    if (sample.sampleType == 'gas') {
      return ListTile(
        trailing: ElevatedButton(
          onPressed: openDetailScreen,
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6200EE)),
          child: const Text(
            "Info",
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          'Gas (${sample.sampleName.toString().length > 0 ? sample.sampleName.toString().trim() : "No name"})',
          style: TextStyle(color: Color(0xFF6200EE)),
        ),
        subtitle: Text(
          'Added by ${sample.researcherEmail} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(sample.date!))}',
          style: TextStyle(color: Colors.blueGrey),
        ),
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.air,
            color: Color(0xFF6200EE),
          ),
        ),
      );
    }
    if (sample.sampleType == 'sediment') {
      return ListTile(
        trailing: ElevatedButton(
          onPressed: openDetailScreen,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text(
            "Info",
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          'Sediment (${sample.sampleName.toString().length > 0 ? sample.sampleName.toString().trim() : "No name"})',
          style: TextStyle(color: Colors.orange),
        ),
        subtitle: Text(
          'Added by ${sample.researcherEmail} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(sample.date!))}',
          style: TextStyle(color: Colors.blueGrey),
        ),
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 241, 244, 246),
          child: Icon(
            Icons.terrain_outlined,
            color: Colors.orange,
          ),
        ),
      );
    }

    // if (sample.sampleType == 'water') {

    // }

    return ListTile(
      trailing: ElevatedButton(
        onPressed: openDetailScreen,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
        child: const Text(
          "Info",
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        "Water (${sample.sampleName.toString().length > 0 ? sample.sampleName.toString().trim() : "No name"})",
        style: TextStyle(color: Colors.lightBlue),
      ),
      subtitle: Text(
        'Added by ${sample.researcherEmail} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(sample.date!))}',
        style: TextStyle(color: Colors.blueGrey),
      ),
      leading: const CircleAvatar(
        backgroundColor: Color.fromARGB(255, 241, 244, 246),
        child: Icon(
          Icons.water,
          color: Colors.lightBlue,
        ),
      ),
    );
    // return ListTile(
    //   trailing: ElevatedButton(
    //     onPressed: openDetailScreen,
    //     child: Text(
    //       "Info",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    //   ),
    //   title: Text(
    //     'Organism parts',
    //     style: TextStyle(color: Colors.green),
    //   ),
    //   subtitle: Text('$date'),
    //   leading: CircleAvatar(
    //     backgroundColor: Color.fromARGB(255, 241, 244, 246),
    //     child: Icon(
    //       Icons.science_outlined,
    //       color: Colors.green,
    //     ),
    //   ),
    // );
  }
}
