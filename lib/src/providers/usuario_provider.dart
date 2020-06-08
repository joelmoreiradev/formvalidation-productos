import 'dart:convert';

import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;


class UsuarioProvider {

  final String _firebaseApiKey = 'AIzaSyCRzQDIh_lO_qWtetgEwXGk5FSksZLketA'; // API KEY que usará la url
  final _prefs = new PreferenciasUsuario();

  // función login
  Future<Map<String, dynamic>> login(String email, String password) async {

    final authData = {   // mapa donde se almacenan los datos recibidos por la función nuevoUsuario, que luego serán convertidos a json y enviados en el POST.
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };
  
    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseApiKey', // url de la api a la que haré el POST.
      body: json.encode(authData) // envío los datos de authData, pero en formato json.
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    // si decodedResp contiene idToken significa que todo está Ok.
    if(decodedResp.containsKey('idToken') ) {
      // TODO: Salvar el token en el storage.
      _prefs.token = decodedResp['idToken'];


      return {'ok': true, 'token': decodedResp['idToken']};

    //de lo contrario hay un error y muestro el error.
    } else {
      //dentro de error, retorno el contenido de message
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }




  }
  
  Future<Map<String, dynamic>> nuevoUsuario(String email, String password)async{ // función que recibe correo y contraseña como argumentos

    final authData = {   // mapa donde se almacenan los datos recibidos por la función nuevoUsuario, que luego serán convertidos a json y enviados en el POST.
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };
  
    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseApiKey', // url de la api a la que haré el POST.
      body: json.encode(authData) // envío los datos de authData, pero en formato json.
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    // si decodedResp contiene idToken significa que todo está Ok.
    if(decodedResp.containsKey('idToken') ) {
      // TODO: Salvar el token en el storage.
      _prefs.token = decodedResp['idToken'];


      return {'ok': true, 'token': decodedResp['idToken']};

    //de lo contrario hay un error y muestro el error.
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }





  }

}