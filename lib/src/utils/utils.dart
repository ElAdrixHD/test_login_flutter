
import 'package:flutter/material.dart';

bool isNumber(String s){
  if(s.isEmpty) return false;

  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String msg){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text("Atención"),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(child: Text("OK"), onPressed: () => Navigator.of(context).pop())
      ],
    );
  });
}