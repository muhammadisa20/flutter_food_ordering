import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationPage extends StatefulWidget {
  SelectLocationPage({Key key}) : super(key: key);

  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  LatLng latLng = LatLng(11.5774552, 104.9038566);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.5774552, 104.9038566),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
    target: LatLng(11.5774552, 104.9038566),
    zoom: 19.151926040649414,
  );

  void getLocationAddress() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemark.length > 0) print(placemark[0].toString());
  }

  @override
  void initState() {
    var markerIdVal = 'trssdas';
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(11.5774552, 104.9038566),
    );
    setState(() {
      markers[markerId] = marker;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Select Map')),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (cameraPosition) {
              latLng = LatLng(cameraPosition.target.latitude.toDouble(), cameraPosition.target.longitude.toDouble());
              print('Lat: ${cameraPosition.target.latitude}, Long: ${cameraPosition.target.longitude}');
            },
            onCameraIdle: () {
              getLocationAddress();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
