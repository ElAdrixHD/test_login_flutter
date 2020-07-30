import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/login_bloc.dart';
import 'package:form_validation/src/blocs/productos_bloc.dart';

class Provider extends InheritedWidget{
  final loginBloc = LoginBloc();
  final _productoBloc = ProductosBloc();

  Provider({Key key, Widget child}) : super(key: key, child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productoBloc;
  }
}