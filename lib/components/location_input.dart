import 'package:flutter/material.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:labtracking/screens/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/point.dart';

class LocationInput extends StatefulWidget with ChangeNotifier {
  Coords? point;

  Coords? get getCoords {
    return point;
  }

  void setCoords(Coords point) {
    this.point = point;
    notifyListeners();
  }

  void clear() {
    point = null;
    notifyListeners();
  }

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  double? lat;
  double? long;
  LocationPermission? permission;

  CameraPosition? cameraPosition;
  GoogleMapController? mapController;

  bool isLoading = false;

  Future<void> _getCurrentUserLocation(Coords point) async {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final locData = await Geolocator.getCurrentPosition();
    print(locData);
    setState(
      () {
        lat = locData.latitude;
        long = locData.longitude;
        cameraPosition = CameraPosition(
          target: LatLng(lat!, long!),
          zoom: 13,
        );
      },
    );
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition!),
    );

    print("${lat!} + ${long!} OK");
    point.changeCoordinates(lat!, long!);
    widget.setCoords(point);
  }

  Future<void> _selectOnMap(Coords point) async {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final locData = await Geolocator.getCurrentPosition();

    setState(
      () {
        lat = locData.latitude;
        long = locData.longitude;
        cameraPosition = CameraPosition(
          target: LatLng(lat!, long!),
          zoom: 13,
        );
      },
    );
    point.changeCoordinates(lat!, long!);
    widget.setCoords(point);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition!),
    );

    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(lat: lat!, long: long!),
        fullscreenDialog: true,
      ),
    );
    setState(() {
      isLoading = false;
    });

    if (selectedPosition == null) return;

    setState(() {
      lat = selectedPosition.latitude;
      long = selectedPosition.longitude;
      cameraPosition = CameraPosition(
        target: LatLng(lat!, long!),
        zoom: 13,
      );
    });
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition!),
    );
    point.changeCoordinates(lat!, long!);
    widget.setCoords(point);
    print("AQUI::::::::${widget.point!.lat} + ${widget.point!.long}");
    point.lat = lat!;
    point.long = long!;
  }

  @override
  Widget build(BuildContext context) {
    final point = Provider.of<Coords>(context, listen: false);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: lat == null && long == null
              ? const Center(
                  child: Text(
                    'No location',
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: GoogleMap(
                      initialCameraPosition: cameraPosition!,
                      markers: {
                        Marker(
                          markerId: const MarkerId('p1'),
                          position: LatLng(lat!, long!),
                        ),
                      },
                      mapType: MapType.satellite,
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                        });
                      },
                    ),
                  ),
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TextButton.icon(
            //   onPressed: () => _getCurrentUserLocation(point),
            //   icon: Icon(
            //     Icons.location_on,
            //     size: 16,
            //     color: Theme.of(context).errorColor,
            //   ),
            //   label: const Text(
            //     "Pegar localização",
            //     style: TextStyle(
            //       fontSize: 13,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
            isLoading == false
                ? ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      _selectOnMap(point);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                    ),
                    icon: const Icon(Icons.gps_fixed_sharp,
                        size: 16, color: Colors.amber),
                    label: const Text(
                      "Select location on map",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: CircularProgressIndicator(),
                  )
          ],
        ),
        const SizedBox(
          height: 0,
        )
      ],
    );
  }
}
