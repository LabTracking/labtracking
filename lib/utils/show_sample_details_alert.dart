import 'package:flutter/material.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/utils/capitalize.dart';

void showSampleDetailsDialog(BuildContext context, Sample sample) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              color: Colors.blue,
            ),
            Text(
              ' Sample Details',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildDetailRow('Name',
                  sample.sampleName != "" ? sample.sampleName : "No name"),
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
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
  final firstAnalysis = analysis.first.entries.first;
  final firstAnalysisText =
      '${firstAnalysis.key.toString().toUpperCase()}: ${firstAnalysis.value}';

  // Format the remaining analysis items
  final remainingAnalysis = analysis.skip(1).toList();
  final remainingAnalysisText = _formatAnalysis(remainingAnalysis);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDetailRow('Analysis', firstAnalysisText),
      if (remainingAnalysis.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 4.0),
          child: Text(
            remainingAnalysisText,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
    ],
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
