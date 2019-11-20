import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/app_constant.dart';
import 'package:flutter_food_ordering/pages/home_page.dart';
import 'package:flutter_food_ordering/pages/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SpashlScreenPage extends StatefulWidget {
  @override
  _SpashlScreenPageState createState() => _SpashlScreenPageState();
}

class _SpashlScreenPageState extends State<SpashlScreenPage> {
  void getData() async {
    final fss = FlutterSecureStorage();
    String token = await fss.read(key: 'token');
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => token == null ? LoginPage() : MyHomePage()),
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('FOOD ORDERING', style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 32),
          Text('Ordering food more easy!!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
          SizedBox(height: 32),
          CupertinoActivityIndicator(radius: 20),
        ],
      ),
    );
  }
}
