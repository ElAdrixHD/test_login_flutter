import 'dart:async';

class LoginBloc{
  final _emailController = StreamController.broadcast();
  final _passwordController = StreamController.broadcast();

  //Recuperar datos stream
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  //Insertar valores stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }
}