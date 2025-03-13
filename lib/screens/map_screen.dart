import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double long;

  final bool isReadOnly;

  const MapScreen({
    super.key,
    this.lat = -22,
    this.long = -43,
    this.isReadOnly = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 217, 87),
        title: const Text('Select...', style: TextStyle(color: Colors.white)),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              onPressed: _pickedPosition == null
                  ? null
                  : () => Navigator.of(context).pop(_pickedPosition),
              icon: const Icon(Icons.check),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.long),
          zoom: 13,
        ),
        mapType: MapType.hybrid,
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: _pickedPosition == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('p1'),
                  position: _pickedPosition!,
                )
              },
      ),
    );
  }
}
