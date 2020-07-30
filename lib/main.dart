import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/pages/home_page.dart';
import 'package:form_validation/src/pages/login_page.dart';
import 'package:form_validation/src/pages/producto_page.dart';
import 'package:form_validation/src/pages/registro_page.dart';
import 'package:form_validation/src/utils/preferencias_usuario.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferences = new PreferenciasUsuario();
    print("Main: ${preferences.token}");
    return Provider(
      child: MaterialApp(
        title: 'Formularios',
        debugShowCheckedModeBanner: false,
        initialRoute: LoginPage.route,
        routes: {
          LoginPage.route : (BuildContext context) => LoginPage(),
          HomePage.route : (BuildContext context) => HomePage(),
          ProductPage.route : (BuildContext context) => ProductPage(),
          RegistroPage.route : (BuildContext context) => RegistroPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );
  }
}