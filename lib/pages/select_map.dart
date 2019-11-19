import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/location_picked_model.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class DeliveryLocationPage extends StatefulWidget {
  final double lat;
  final double lng;
  DeliveryLocationPage({Key key, this.lat, this.lng}) : super(key: key);

  _DeliveryLocationPageState createState() => _DeliveryLocationPageState();
}

class _DeliveryLocationPageState extends State<DeliveryLocationPage> {
  GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  LatLng latLng;
  ApiProvider apiProvider = getIt<ApiProvider>();
  LocationPickedModel locationPickedModel;
  Geolocator geoLocator = Geolocator();
  Future<CameraPosition> currentPos;

  Position position;
  CameraPosition currentPosition;
  ValueNotifier<String> locationString = ValueNotifier<String>('no data');

  Future<CameraPosition> getCurrentLocation() async {
    if (widget.lat != null) {
      getLocationAddress(widget.lat, widget.lng);
      currentPosition = CameraPosition(
        zoom: 17,
        target: LatLng(widget.lat, widget.lng),
      );
    } else {
      position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition = CameraPosition(
        zoom: 17,
        target: LatLng(position.latitude, position.longitude),
      );
      getLocationAddress(position.latitude, position.longitude);
    }

    var marker = Marker(
        markerId: MarkerId('current'),
        icon: await createBitMapFromCanvas(),
        position: LatLng(currentPosition.target.latitude, currentPosition.target.longitude));

    setState(() {
      markers[MarkerId('current')] = marker;
    });

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
        address:
            '${placeMarks[0].name}, ${placeMarks[0].thoroughfare}, ${placeMarks[0].subLocality}, ${placeMarks[0].locality}',
        lat: placeMarks[0].position.latitude,
        lng: placeMarks[0].position.longitude,
      );

      locationString.value = locationPickedModel.toString();
    }
  }

  void updateDeliveryLocation() {
    apiProvider.updateUserDeliveryLocation(locationPickedModel).then((value) {
      Toast.show('Delivery location updated', context);
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
                    markers: markers.values.toSet(),
                    mapType: MapType.normal,
                    initialCameraPosition: snapshot.data,
                    onMapCreated: (GoogleMapController controller) {
                      googleMapController = controller;
                    },
                    onCameraMove: (cameraPosition) {
                      locationString.value = '';
                      latLng =
                          LatLng(cameraPosition.target.latitude.toDouble(), cameraPosition.target.longitude.toDouble());
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

  Future<BitmapDescriptor> createBitMapFromCanvas() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder, Rect.fromPoints(const Offset(0.0, 0.0), const Offset(200.0, 200.0)));
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(0.0, 0.0, 200.0, 200.0), const Radius.circular(8.0)), paint);
    paintText(canvas);
//    paintImage(labelIcon, const Rect.fromLTWH(8, 8, 32.0, 32.0), canvas, paint, BoxFit.contain);
//    ByteData data = await rootBundle.load('assets/pin.png');
//    ui.Image markerImage = Image.memory(data.buffer.asUint8List()) as ui.Image;
//    paintImage(markerImage, const Rect.fromLTWH(24.0, 48.0, 110.0, 110.0), canvas, paint, BoxFit.contain);
    final ui.Picture picture = recorder.endRecording();
    final img = await picture.toImage(200, 200);
    final pngByteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(Uint8List.view(pngByteData.buffer));
  }

  void paintText(Canvas canvas) {
    final textSpan = TextSpan(
      text: 'My location',
      style: TextStyle(color: Colors.white, fontSize: 32),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 200,
    );
    final offset = Offset(12, 12);
    textPainter.paint(canvas, offset);
  }

  paintImage(ui.Image image, Rect outputRect, Canvas canvas, Paint paint, BoxFit fit) async {
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(fit, imageSize, outputRect.size);
    final Rect inputSubrect = Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect = Alignment.center.inscribe(sizes.destination, outputRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
  }
}
