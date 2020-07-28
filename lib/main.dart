import 'package:flutter/material.dart';
import 'package:form_validation/src/pages/home_page.dart';
import 'package:form_validation/src/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formularios',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route : (BuildContext context) => LoginPage(),
        HomePage.route : (BuildContext context) => HomePage(),
      },
    );
  }
}