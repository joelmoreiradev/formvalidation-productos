import 'dart:async';

import 'package:formvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
   
   // controller de email & password. Tienen .broadcast para poder ser "escuchados" desde varios lados.
   // estos dos StreamController son como 2 tuberías, los datos del campo de email van a pasar por una tubería y los de password por otra.
   final _emailController = BehaviorSubject<String>();  //tubería de email
   final _passwordController = BehaviorSubject<String>();  //tubería de password
   
   
   
   

  /* todo esté código de abajo solo es una conveniencia para no tener que escribir todo
     el tiempo '_emailController.stream, .sink...' etc.  */

  
   // Recuperar los datos validados de los Stream / escucharlos (esta es la salida)
   Stream<String> get emailStream => _emailController.stream.transform(validarEmail);   //Cuando necesite recuperar datos de email, usaré emailStream
   Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword); //Cuando necesite recuperar datos de password, usaré passwordStream

  
  // combinar emailStream y passwordStream.
   Stream<bool> get formValidStream => 
                                    // si hay data en ambos streams, retorna true, caso contrario null.
       CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);


   // Insertar valores al Stream
   // Ej: cuando llame al getter changeEmail, va a ejecutar _emailController.sink.add;
   Function(String) get changeEmail => _emailController.sink.add;
   Function(String) get changePassword => _passwordController.sink.add;



  // Obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;





   // cerrar los StreamController cuando no los necesito.
   dispose() {
     // el '?' es para que si los StreamController fueran null, no diera error al cerrar.
     _emailController?.close();
     _passwordController?.close();
   }




}

