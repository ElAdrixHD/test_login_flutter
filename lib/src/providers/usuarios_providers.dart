import 'dart:convert';

import 'package:form_validation/src/utils/preferencias_usuario.dart';
import 'package:http/http.dart';

class UsuarioProvider{

  final String _firebaseToken = "AIzaSyASdU5Kzp2oNuowyvMajM9AVTRstOYazbQ";
  final pref = PreferenciasUsuario();

  Future<Map<String, dynamic>> nuevoUser(String email, String pass) async{
    final authData = {
      "email" : email,
      "password" : pass,
      "returnSecureToken" : true
    };

    final resp = await post("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken",
      body: json.encode(authData),
    );

    Map<String, dynamic> decodedData = json.decode(resp.body);
    print(decodedData);
    if(decodedData.containsKey("idToken")){
      pref.token = decodedData["idToken"];
      return {"ok": true, "token": decodedData["idToken"]};
    }else{
      return {"ok": false, "error": decodedData["error"]["message"]};
    }
  }

  Future<Map<String, dynamic>> loginUsuario(String email, String pass) async{
    final authData = {
      "email" : email,
      "password" : pass,
      "returnSecureToken" : true
    };

    final resp = await post("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken",
      body: json.encode(authData),
    );

    Map<String, dynamic> decodedData = json.decode(resp.body);
    print(decodedData);
    if(decodedData.containsKey("idToken")){
      pref.token = decodedData["idToken"];
      return {"ok": true, "token": decodedData["idToken"]};
    }else{
      return {"ok": false, "error": decodedData["error"]["message"]};
    }
  }
}