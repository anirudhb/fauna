import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int id = 0;

  void _add(latitude, longitude) {
    var markerIdVal = id;
    id++;
    final MarkerId markerId = MarkerId(markerIdVal.toString());

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
          title: markerIdVal.toString(),
          snippet: '*'), // TODO change this to # of animals or something
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {}

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void _addMarkerValues() {
    // get marker values here with GET request
    // iterate over them and call the '_add(lat, long)' function above for each value
  }

  @override
  void initState() {
    super.initState();

    _addMarkerValues();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }
}
