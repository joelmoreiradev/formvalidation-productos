/* En esta clase Validators lo que hago es validar la información que
   ingreso en los TextField para dejar que fluya o no por el Stream. 
   Para eso creo un StreamTransformer para "transformar" o "filtrar"
   la información que pasará por el Stream de la contraseña. */

/* Luego  */


import 'dart:async';

class Validators {

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    
    //el sink es para dejar fluír información o bloquearla
    handleData: (email, sink){

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if(regExp.hasMatch(email)){
        sink.add(email);
      }
      else {
        sink.addError('Email inválido');
      }
     

    }
  );




  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    
    //el sink es para dejar fluír información o bloquearla
    handleData: (password, sink){
  
    // si la contraseña es mayor o igual a 6 caracteres, dejo que fluya por el Stream.
      if(password.length >= 6){
        // aquí dejo fluír la contraseña a través del Stream.
        sink.add(password);
      } 
      
      // caso contrario la contraseña es muy corta, y debo mostrar un error.
      else {
       sink.addError('Mínimo 6 caracteres.');
      }

    }
  );


  

}