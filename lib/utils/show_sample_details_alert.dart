import 'package:flutter/material.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/screens/edit_sample.dart';
import 'package:labtracking/utils/capitalize.dart';

void showSampleDetailsDialog(
  BuildContext context,
  Sample sample,
  Map<String, dynamic> researcherData,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: sample.level! > 0
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                  Text(
                    ' Derived sample details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text(" Main sample details",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (sample.level == 0)
                if (sample.level == 0)
                  const SizedBox(
                    height: 15,
                  ),
              _buildDetailRow('Name',
                  sample.sampleName != "" ? sample.sampleName : "No name"),
              _buildDetailRow('Weight (g)',
                  sample.weight != "" ? sample.weight : "No weight"),
              _buildDetailRow('Date', sample.date),
              _buildDetailRow('Entry Date', sample.entryDate),
              _buildDetailRow('Exit Date', sample.exitDate),
              _buildDetailRow('Lab Location', sample.location),
              _buildDetailRow('Storage Condition', sample.storageCondition),
              _buildDetailRow('Ecosystem', sample.ecosystem),
              _buildDetailRow('Latitude', sample.latitude?.toString()),
              _buildDetailRow('Longitude', sample.longitude?.toString()),
              _buildDetailRow('Exists',
                  sample.exists != null && sample.exists! ? 'Yes' : 'No'),
              _buildDetailRow('Provider', sample.provider),
              _buildDetailRow(
                  'Storage Temperature', sample.storageTemperature?.join(', ')),
              _buildDetailRow('Obs.', sample.observation),
              _buildAnalysisRow(sample.analysis),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: (sample.level != null &&
                        sample.level! > 0 &&
                        researcherData["type"] != "observer")
                    ? () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => EditSample(
                              sample: sample,
                              researcherData: researcherData,
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                    : null,
                icon: (sample.level != null &&
                        sample.level! > 0 &&
                        researcherData["type"] != "observer")
                    ? const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      )
                    : const Icon(
                        Icons.edit,
                        color: Colors.black12,
                      ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget _buildDetailRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: TextStyle(color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _buildAnalysisRow(List<Map<dynamic, dynamic>>? analysis) {
  if (analysis == null || analysis.isEmpty) {
    return _buildDetailRow('Analysis', 'N/A');
  }

  // Extract the first analysis item
  // final firstAnalysis = analysis.first.entries.first.key;
  // final firstAnalysisText =
  //     '${firstAnalysis.key.toString().toUpperCase()}: ${firstAnalysis.value}';

  // // Format the remaining analysis items
  // final remainingAnalysis = analysis.skip(1).toList();
  // final remainingAnalysisText = _formatAnalysis(remainingAnalysis);

  List<Widget> analysisWidgets = [
    _buildDetailRow("Analysis", ""),
  ];

  for (int i = 0; i < analysis.length; i++) {
    analysisWidgets.add(
      _buildDetailRow("  -${analysis[i]["name"]}", analysis[i]["result"]),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: analysisWidgets,
  );
}

String _formatAnalysis(List<Map<dynamic, dynamic>> analysis) {
  return analysis.map((item) {
    return item.entries.toList().reversed.map((entry) {
      String formattedKey = capitalize(
          entry.key.toString()); //.toUpperCase(); // Capitalize the key
      return '$formattedKey: ${entry.value}';
    }).join('\n');
  }).join('\n\n');
}
