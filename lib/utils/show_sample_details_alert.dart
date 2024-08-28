import 'package:flutter/material.dart';
import 'package:labtracking/models/sample.dart';

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
              _buildDetailRow(
                  'Analysis',
                  sample.analysis != null
                      ? _formatAnalysis(sample.analysis!)
                      : null),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: Colors.red,
            ),
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

String _formatAnalysis(List<Map<dynamic, dynamic>> analysis) {
  return analysis.map((item) => item.toString()).join(', ');
}
