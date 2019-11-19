class LocationPickedModel {
  String address;
  num lat;
  num lng;

  @override
  String toString() {
    return '$address';
  }

  LocationPickedModel({this.address, this.lat, this.lng});
}
