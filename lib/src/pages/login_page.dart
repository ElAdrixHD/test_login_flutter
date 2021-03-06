import 'dart:math';

import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/login_bloc.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/pages/home_page.dart';
import 'package:form_validation/src/pages/registro_page.dart';
import 'package:form_validation/src/providers/usuarios_providers.dart';
import 'package:form_validation/src/utils/utils.dart';

class LoginPage extends StatelessWidget {
  static final route = "/login";
  final provider = UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(context),
          _card(context),
        ],
      )
    );
  }

  Widget _background(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondo = Container(
      height: size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ]
        )
      ),
    );

    final circulo = AnimatedContainer(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ), duration: Duration(milliseconds: 200),
    );

    return Stack(
      children: <Widget>[
        fondo,
        Transform.translate(offset: Offset(Random().nextDouble()*size.width,Random().nextDouble()*size.height*0.3),child: circulo,),
        Transform.translate(offset: Offset(Random().nextDouble()*size.width,Random().nextDouble()*size.height*0.3),child: circulo,),
        Transform.translate(offset: Offset(Random().nextDouble()*size.width,Random().nextDouble()*size.height*0.3),child: circulo,),
        Transform.translate(offset: Offset(Random().nextDouble()*size.width,Random().nextDouble()*size.height*0.3),child: circulo,),
        //Positioned(top: Random().nextDouble()*size.height*0.3, left: Random().nextDouble()*size.width, child: circulo),
        //Positioned(top: Random().nextDouble()*size.height*0.3, left: Random().nextDouble()*size.width, child: circulo),
        //Positioned(top: Random().nextDouble()*size.height*0.3, left: Random().nextDouble()*size.width, child: circulo),
        //Positioned(top: Random().nextDouble()*size.height*0.3, left: Random().nextDouble()*size.width, child: circulo),
        //Positioned(top: Random().nextDouble()*size.height*0.3, left: Random().nextDouble()*size.width, child: circulo),
        //Positioned(top: Random().nextDouble()*size.height*0.3, left: Random().nextDouble()*size.width, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              SizedBox(height: 10.0, width: double.infinity,),
              Text("Adrian Muñoz", style: TextStyle(color: Colors.white, fontSize: 25.0),)
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(height: size.height*0.2),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.only(top: size.height*0.1),
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black26, blurRadius: 3.0, offset: Offset(0.0,5.0), spreadRadius: 3.0),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text("Ingreso", style: TextStyle(fontSize: 20.0),),
                SizedBox(height: 20.0,),
                _fields(bloc),
                _boton(context, bloc),
              ],
            ),
          ),
          SizedBox(height: 50.0,),
          FlatButton(onPressed: ()=> Navigator.pushNamed(context, RegistroPage.route), child: Text("Crear cuenta")),
          SizedBox(height: 100.0,)
        ],
      ),
    );
  }

  Widget _fields(LoginBloc bloc) {

    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: bloc.emailStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal:20.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
                    hintText: "ejemplo@example.com",
                    labelText: "Correo Electrónico",
                    counterText: snapshot.data,
                    errorText: snapshot.error,
                ),
                  onChanged: (String value) => bloc.changeEmail(value)
              ),
            );
          },
        ),
        SizedBox(height: 30.0,),
        StreamBuilder(
          stream: bloc.passwordStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal:20.0),
              child: TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline, color: Colors.deepPurple,),
                    labelText: "Contraseña",
                    counterText: snapshot.data,
                    errorText: snapshot.error,
                ),
                onChanged: (String value) => bloc.changePassword(value),
              ),
            );
          },
        ),
        SizedBox(height: 30.0,),
      ],
    );
  }

  Widget _boton(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          onPressed: (snapshot.hasData) ? (){ _login(context, bloc);} : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.deepPurple,
          textColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text("Iniciar sesión"),
          ),
        );
      },);
  }

  _login(BuildContext context, LoginBloc bloc)async{
    final res = await provider.loginUsuario(bloc.email, bloc.password);
    if(res["ok"]){
      Navigator.pushReplacementNamed(context, HomePage.route);
    }else {
      mostrarAlerta(context, res["error"]);
    }
    //Navigator.pushReplacementNamed(context, HomePage.route);
  }
}
