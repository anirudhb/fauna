import 'dart:async';
import 'dart:convert';

import 'package:fauna_frontend/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int id = 0;

  void _add(double latitude, double longitude, String firstAnimal) {
    var markerIdVal = id;
    id++;
    final MarkerId markerId = MarkerId(markerIdVal.toString());

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
      infoWindow:
          InfoWindow(title: markerIdVal.toString(), snippet: firstAnimal),
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

  Future<void> _addMarkerValues() async {
    final location = await getLocation();
    if (location == null) return;
    (await _controller.future).animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(location.latitude, location.longitude), 15));

    final r = await http.get(Uri.parse(
        "https://decisive-router-311716.uc.r.appspot.com/nearbyanimalsightings?lat=${location.latitude}&lng=${location.longitude}"));
    final r2 = jsonDecode(r.body);
    for (String uuid in (r2 as List<dynamic>).cast<String>()) {
      //fetch
      final r3 = await http.get(Uri.parse(
          "https://decisive-router-311716.uc.r.appspot.com/animalsighting/$uuid"));
      final r4 = jsonDecode(r3.body);
      final coords = r4["coords"];
      final animals = (r4["animals"] as List<dynamic>).cast<String>();
      print(
          "sighting latlng = $coords, ours is ${location.latitude} ${location.longitude}");
      _add(coords[0], coords[1], animals[0]);
    }
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
        myLocationEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }
}
