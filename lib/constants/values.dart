import 'package:flutter/material.dart';

//color
Color mainColor = Color.fromRGBO(255, 204, 0, 1);
const String BASE_URL = 'http://10.0.2.2:8000';
//const String BASE_URL = 'http://192.168.88.137:8000';
//const String BASE_URL = 'http://localhost:8000';
String userId = '5dcc00806b416c12ecc5bd93';
String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZGNjMDA4MDZiNDE2YzEyZWNjNWJkOTMiLCJpYXQiOjE1NzM4NTkyNjZ9.7NIoCpmwIqqu9ahMzI4FoXDDaVcLXbqDEG54gYUlxIU';

//Style
final headerStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
final titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
final titleStyle2 = TextStyle(fontSize: 16, color: Colors.black45);
final subtitleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
final infoStyle = TextStyle(fontSize: 12, color: Colors.black54);

//Decoration
final roundedRectangle12 = RoundedRectangleBorder(
  borderRadius: BorderRadiusDirectional.circular(12),
);

final roundedRectangle4 = RoundedRectangleBorder(
  borderRadius: BorderRadiusDirectional.circular(4),
);

final roundedRectangle40 = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
);
