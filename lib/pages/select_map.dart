import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/location_picked_model.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class DeliveryLocationPage extends StatefulWidget {
  DeliveryLocationPage({Key key}) : super(key: key);

  _DeliveryLocationPageState createState() => _DeliveryLocationPageState();
}

class _DeliveryLocationPageState extends State<DeliveryLocationPage> {
  GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  LatLng latLng;
  ApiProvider apiProvider = getIt<ApiProvider>();
  LocationPickedModel locationPickedModel;
  Geolocator geolocator = Geolocator();
  Future<CameraPosition> currentPos;

  Position position;
  CameraPosition currentPosition;
  ValueNotifier<String> locationString = ValueNotifier<String>('no data');

  Future<CameraPosition> getCurrentLocation() async {
    position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = CameraPosition(
      zoom: 17,
      target: LatLng(position.latitude, position.longitude),
    );
    getLocationAddress(position.latitude, position.longitude);
    return currentPosition;
  }

  CameraPosition get currentLocation => CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17,
      );

  void getLocationAddress(double lat, double lng) async {
    List<Placemark> placeMarks = await Geolocator().placemarkFromCoordinates(lat, lng);
    if (placeMarks.length > 0) {
      print(placeMarks[0].toJson());
      locationPickedModel = LocationPickedModel(
        address: '${placeMarks[0].name}, ${placeMarks[0].thoroughfare}, ${placeMarks[0].subLocality}, ${placeMarks[0].locality}',
        lat: placeMarks[0].position.latitude,
        lng: placeMarks[0].position.longitude,
      );

      locationString.value = locationPickedModel.toString();
    }
  }

  void updateDeliveryLocation() {
    apiProvider.updateUserDeliveryLocation(locationPickedModel).then((value) {
      Toast.show('Delivery location update success', context);
      Navigator.pop(context, true);
    }).catchError((error) {
      Toast.show(error.toString(), context);
    });
  }

  void gotoCurrentLocation() async {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(currentLocation));
  }

  @override
  void initState() {
    currentPos = getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Select Delivery Location'),
        backgroundColor: mainColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: gotoCurrentLocation,
          )
        ],
      ),
      body: FutureBuilder<CameraPosition>(
          future: currentPos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  GoogleMap(
                    markers: Set<Marker>.of(markers.values),
                    mapType: MapType.normal,
                    initialCameraPosition: snapshot.data,
                    onMapCreated: (GoogleMapController controller) {
                      googleMapController = controller;
                    },
                    onCameraMove: (cameraPosition) {
                      locationString.value = '';
                      latLng = LatLng(cameraPosition.target.latitude.toDouble(), cameraPosition.target.longitude.toDouble());
                      print('Lat: ${cameraPosition.target.latitude}, Long: ${cameraPosition.target.longitude}');
                    },
                    onCameraIdle: () {
                      getLocationAddress(latLng.latitude, latLng.longitude);
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(bottom: 12),
                      child: FlareActor(
                        "assets/pin.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "Search",
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Container(
                  //     width: 10,
                  //     height: 10,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  ValueListenableBuilder(
                    valueListenable: locationString,
                    builder: (context, value, child) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 50,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                              padding: EdgeInsets.only(right: 24, left: 8, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: mainColor,
                              ),
                              child: Center(
                                child: value == ''
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      )
                                    : Text(value),
                              ),
                            ),
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: mainColor,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.all(4),
                                  onPressed: updateDeliveryLocation,
                                  iconSize: 32,
                                  icon: Icon(Icons.add_location, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height / 2 - 50),
                  Text('Getting current location'),
                  SizedBox(height: 16),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }),
    );
  }
}
