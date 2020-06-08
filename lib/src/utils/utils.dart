

// esto es una función para saber si un valor es un número.
import 'package:flutter/material.dart';

bool isNumeric(String s){

  // si el String S está vacío, retornar false.
  if (s.isEmpty) return false;

  // esto es para saber si se puede transformar o "parsear" el valor del String S a un número.
  final n = num.tryParse(s);

  // si n es null, retornar false, de lo contrario retornar true.
  // si n es true, significa que es un número válido.
  return (n == null ) ? false : true;
  
}

void mostrarAlerta(BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
         title: Text('Información incorrecta'),
         content: Text(mensaje),
         actions: <Widget>[
           FlatButton(
            // cerrar el AlertDialog.
           child: Text('Ok'),
           onPressed: ()=> Navigator.of(context).pop(), 
           ),
         ],
      );

    }
  );
}