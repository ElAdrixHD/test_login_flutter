

import 'dart:async';

class Validators{

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink){
        //Patron correo valido
        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        if(RegExp(pattern).hasMatch(email)){
          sink.add(email);
        }else{
          sink.addError("Correo electronico no válido");
        }
      }
  );

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if(password.length >= 8){
        sink.add(password);
      }else{
        sink.addError("La contraseña no puede ser inferior a 8 caracteres");
      }
    }
  );

}