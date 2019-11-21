import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/app_constant.dart';
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
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  ApiProvider apiProvider = getIt<ApiProvider>();
  TextEditingController emailTC = TextEditingController(text: 'user1@gmail.com');
  TextEditingController passwordTC = TextEditingController(text: '123456');
  TextStyle textFieldStyle = TextStyle(fontSize: 20);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ScrollController scrollController;

  //method
  void onLogin(context) {
    if (formKey.currentState.validate()) {
      isLoading.value = true;
      apiProvider.loginUser(emailTC.text, passwordTC.text).then((loginResponse) {
        isLoading.value = false;
        saveUserData(loginResponse);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }).catchError((err) {
        isLoading.value = false;
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err.toString())));
      });
    }
  }

  void saveUserData(LoginResponse loginResponse) {
    final fss = FlutterSecureStorage();
    fss.write(key: 'userId', value: loginResponse.user.id);
    fss.write(key: 'token', value: loginResponse.token);
  }

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(elevation: 0, backgroundColor: mainColor),
      body: ListView(
        controller: scrollController,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                color: mainColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 32),
                      Text('FOOD', style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold)),
                      Container(
                        width: 135,
                        height: 6,
                        color: Colors.black,
                      ),
                      SizedBox(height: 54),
                      TextFormField(
                        onTap: () => scrollController.jumpTo(scrollController.position.maxScrollExtent),
                        controller: emailTC,
                        style: textFieldStyle,
                        validator: (value) => value.length > 6 ? null : 'Please input valid email',
                        decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          hintText: 'email',
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 42),
                      TextFormField(
                        onTap: () => scrollController.jumpTo(scrollController.position.maxScrollExtent),
                        controller: passwordTC,
                        style: textFieldStyle,
                        obscureText: true,
                        validator: (value) => value.length > 5 ? null : 'Please input valid password',
                        decoration: InputDecoration(
                          hintText: 'password',
                          prefixIcon: Icon(Icons.vpn_key, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, loading, child) {
                    return Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.6 - 24, left: 32, right: 32),
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () => onLogin(context),
                        padding: EdgeInsets.all(12),
                        child: loading
                            ? Container(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                              )
                            : Text('Login', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        color: Colors.black,
                      ),
                    );
                  })
            ],
          ),
        ],
      ),
    );
  }
}
