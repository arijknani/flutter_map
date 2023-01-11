import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';





class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  State<LocationPage> createState() => _LocationState();
}

class _LocationState extends State<LocationPage> {
  Location location =  Location();

    late bool _serviceEnabled;
    late PermissionStatus _permissionGranted;
    late LocationData _locationData;

  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    
  

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("hello")),
        body: MapBoxPage(),
      ),
    );
  }
}

class MapBoxPage extends StatefulWidget {
  const MapBoxPage({Key? key}) : super(key: key);

  @override
  State<MapBoxPage> createState() => _MapBoxPageState();
}

class _MapBoxPageState extends State<MapBoxPage> {
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;

  @override
  void initState(){
    super.initState();
    _initialCameraPosition= const CameraPosition(target: LatLng(37.222, -122.2233),zoom: 15 );
  }

  _onMapCreated(MapboxMapController controller) async {
  this.controller = controller;
}

  Widget build(BuildContext context) {
    return Material(
      child: MapboxMap(
        styleString: 'mapbox://styles/ahmedj92/ckwqjprr2a2pn15p2un74q7tw',
        initialCameraPosition: _initialCameraPosition,
        accessToken: 'pk.eyJ1IjoiYWhtZWRqOTIiLCJhIjoiY2t3cWpsNjM0MG5nczJ3bDBoZWJrYTJtbyJ9.1kAfeEleSjkYKRZEKFWfsw',
        myLocationEnabled: true,
        myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
        minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
        ),
    );
    
  }
}
