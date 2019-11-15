import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/pages/home_page.dart';
import 'package:flutter_food_ordering/resources/api_provider.dart';
import 'package:flutter_food_ordering/viewmodels/cart_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

GetIt getIt = GetIt.instance;

void main() {
  setUpLocator();
  return runApp(MyApp());
}

void setUpLocator() {
  getIt.registerLazySingleton(() => ApiProvider());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => MyCartViewModel(),
      child: MaterialApp(
        title: 'Flutter Food Ordering',
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
