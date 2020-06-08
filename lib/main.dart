import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/producto_page.dart';
import 'package:formvalidation/src/pages/registro_page.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
 
void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();

  // IMPORTANTE: es importante inicializar las preferencias de usuario antes del runApp, de lo contrario tendré un error.
  //preferencias de usuario
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  // app
  runApp(MyApp());
  
  
} 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    // test para ver si se guardaron las preferencias.
    
    final prefs = new PreferenciasUsuario();
    print(prefs.token);

     return Provider(
        child:  MaterialApp(
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'registro' : (BuildContext context) => RegistroPage(),
          'login' : (BuildContext context) => LoginPage(),
          'home'  : (BuildContext context) => HomePage(),
          'producto'  : (BuildContext context) => ProductoPage(),
        },

        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
  
      ),
  
    ); 
      
    
    
   
  }
}