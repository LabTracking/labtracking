import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labtracking/models/sample.dart';
import 'package:labtracking/screens/sample_details_screen.dart';

class SampleItem extends StatefulWidget {
  final Sample sample;

  const SampleItem({
    required this.sample,
    Key? key,
  }) : super(key: key);

  @override
  State<SampleItem> createState() => _SampleItemState();
}

class _SampleItemState extends State<SampleItem> {
  bool _isHovered = false;

  void openDetailScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SampleDetailsScreen(
          sample: widget.sample,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sample.sampleType == 'gas') {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          color:
              _isHovered ? Colors.purple.withOpacity(0.1) : Colors.transparent,
          child: ListTile(
            trailing: ElevatedButton(
              onPressed: openDetailScreen,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF6200EE)),
              child: const Text(
                "Info",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              'Gas (${widget.sample.sampleName!.isNotEmpty ? widget.sample.sampleName!.trim() : "No name"})',
              style: TextStyle(color: Color(0xFF6200EE)),
            ),
            subtitle: Text(
              'Added by ${widget.sample.researcherEmail} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.sample.date!))}',
              style: TextStyle(color: Colors.blueGrey),
            ),
            leading: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 241, 244, 246),
              child: Icon(
                Icons.air,
                color: Color(0xFF6200EE),
              ),
            ),
          ),
        ),
      );
    }

    if (widget.sample.sampleType == 'sediment') {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          color:
              _isHovered ? Colors.orange.withOpacity(0.1) : Colors.transparent,
          child: ListTile(
            trailing: ElevatedButton(
              onPressed: openDetailScreen,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text(
                "Info",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              'Sediment (${widget.sample.sampleName!.isNotEmpty ? widget.sample.sampleName!.trim() : "No name"})',
              style: TextStyle(color: Colors.orange),
            ),
            subtitle: Text(
              'Added by ${widget.sample.researcherEmail} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.sample.date!))}',
              style: TextStyle(color: Colors.blueGrey),
            ),
            leading: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 241, 244, 246),
              child: Icon(
                Icons.terrain_outlined,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      );
    }

    // Default case for "water" or other types
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color:
            _isHovered ? Colors.lightBlue.withOpacity(0.1) : Colors.transparent,
        child: ListTile(
          trailing: ElevatedButton(
            onPressed: openDetailScreen,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
            child: const Text(
              "Info",
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            "Water (${widget.sample.sampleName!.isNotEmpty ? widget.sample.sampleName!.trim() : "No name"})",
            style: TextStyle(color: Colors.lightBlue),
          ),
          subtitle: Text(
            'Added by ${widget.sample.researcherEmail} \n${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.sample.date!))}',
            style: TextStyle(color: Colors.blueGrey),
          ),
          leading: const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 241, 244, 246),
            child: Icon(
              Icons.water,
              color: Colors.lightBlue,
            ),
          ),
        ),
      ),
    );
  }
}
