import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/main.dart';
import 'package:flutter_food_ordering/model/login_response.dart';
import 'package:flutter_food_ordering/pages/home_page.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  ApiProvider apiProvider = getIt<ApiProvider>();
  TextEditingController emailTC = TextEditingController(text: 'user2@gmail.com');
  TextEditingController passwordTC = TextEditingController(text: '123456');
  TextStyle textFieldStyle = TextStyle(fontSize: 20);

  //method
  void onLogin() {
    if (formKey.currentState.validate()) {
      apiProvider.loginUser(emailTC.text, passwordTC.text).then((loginResponse) {
        saveUserData(loginResponse);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }).catchError((err) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
      });
    }
  }

  void saveUserData(LoginResponse loginResponse) {
    final fss = FlutterSecureStorage();
    fss.write(key: 'userId', value: loginResponse.user.id);
    fss.write(key: 'token', value: loginResponse.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                color: mainColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 54),
                      Text('FOOD', style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
                      Container(
                        width: 160,
                        height: 6,
                        color: Colors.black,
                      ),
                      SizedBox(height: 54),
                      TextFormField(
                        controller: emailTC,
                        style: textFieldStyle,
                        validator: (value) => value.length > 6 ? null : 'Please input valid email',
                        decoration: InputDecoration(
                          hintText: 'email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 42),
                      TextFormField(
                        controller: passwordTC,
                        style: textFieldStyle,
                        obscureText: true,
                        validator: (value) => value.length > 5 ? null : 'Please input valid password',
                        decoration: InputDecoration(
                          hintText: 'password',
                          prefixIcon: Icon(Icons.vpn_key),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.7 - 24, left: 32, right: 32),
                width: double.infinity,
                child: RaisedButton(
                  onPressed: onLogin,
                  padding: EdgeInsets.all(12),
                  child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  color: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
