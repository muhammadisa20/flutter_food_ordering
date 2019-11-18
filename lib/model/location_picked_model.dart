class LocationPickedModel {
  String streetName;
  String khan;
  String city;
  num lat;
  num lng;

  @override
  String toString() {
    return '$streetName, $khan, $city';
  }

  LocationPickedModel({this.streetName, this.khan, this.city, this.lat, this.lng});
}
