import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
      
    );
  }

 Widget _loginForm (BuildContext context) {

   // instancia del provider
   final bloc = Provider.of(context);

   final size = MediaQuery.of(context).size;


   
  // SingleChildScrollView es para poder que se pueda hacer scroll en el formulario de login.
   return SingleChildScrollView(
    child: Column(
      children: <Widget>[

       // separación del top para el container de ingreso
       SafeArea(
         child: Container(
           height: 180.0,
         ),
         ),

        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 30.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: <BoxShadow> [
             BoxShadow(
              color: Colors.black26,
              blurRadius: 3.0,
              offset: Offset(0.0, 5.0),
              spreadRadius: 2.0,
             ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Text('Ingreso', style:  TextStyle(fontSize: 20.0)),
              SizedBox(height: 40.0),
              _crearEmail(bloc),
              SizedBox(height: 30.0),
              _crearPassword(bloc),
              SizedBox(height: 30.0),
              _crearBoton(bloc),
            ],
          ),
        ),

        Text('¿Olvidó la contraseña?'),
        SizedBox(height: 50.0),

      ],

    ),
   );
 }


 Widget _crearEmail(LoginBloc bloc){

   return StreamBuilder(
     stream: bloc.emailStream,
    
     builder: (BuildContext context, AsyncSnapshot snapshot){
       
         return Container(
         padding: EdgeInsets.symmetric(horizontal:20.0),
         child: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
            hintText: 'ejemplo@correo.com',
            labelText: 'Correo electrónico',
            counterText: snapshot.data,
            errorText: snapshot.error,
          ),
          onChanged: bloc.changeEmail,
         ),
       );
    

     },
   );
 


 }




 Widget _crearPassword(LoginBloc bloc){
  
   return StreamBuilder(
     //escuchar el stream passwordStream
     stream: bloc.passwordStream,
     builder: (BuildContext context, AsyncSnapshot snapshot){
           return Container(
             padding: EdgeInsets.symmetric(horizontal:20.0),
             child: TextField(
              obscureText: true,

              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.deepPurple),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error,
              ),
             
              onChanged: bloc.changePassword,

             ),
         );
     },
   );

 }


 Widget _crearBoton(LoginBloc bloc){

   // formValidStream


   return StreamBuilder(
     stream: bloc.formValidStream ,
     builder: (BuildContext context, AsyncSnapshot snapshot){
       
          return RaisedButton(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            ),
            color: Colors.deepPurple,
            textColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Ingresar'),
              
           ),
           // si el snaphot tiene data, retornar una función, de lo contrario null.
           onPressed: snapshot.hasData ? ()=> _login(bloc, context) : null,
   );


     },
   );

 }


 _login(LoginBloc bloc, BuildContext context){
   print('=========================');
   print('Email: ${bloc.email}');
   print('Password: ${bloc.password}');
   print('=========================');

   Navigator.pushReplacementNamed(context, 'home');

 }



 Widget _crearFondo(BuildContext context) {

   // medida de la pantalla
   final size = MediaQuery.of(context).size;

   // almaceno los widgets que voy a usar en el Stack, en variables.
   final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: <Color> [
          Color.fromRGBO(63, 63, 146, 1.0),
          Color.fromRGBO(90, 70, 230, 1.0)
        ])
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    final nombreConIcono = Container(

          // padding de 30 desde el top
          padding: EdgeInsets.only(top: 40.0),

          // hijo del Container
          child: Column(
            // Column siempre lleva children (Lista de widgets)
            children: <Widget>[
              Icon(Icons.person_pin_circle, size: 60.0, color: Colors.white,),

              // el sizedbox tiene un ancho de double.infinity para que ocupe todo el ancho posible y el Column centre los otros widgets.
              SizedBox(height: 10.0, width: double.infinity),
              Text('Joel Moreira', style: TextStyle(color: Colors.white, fontSize: 20.0,),)
            ],
          ),
        );

   
   return Stack(
      children: <Widget>[
        // fondo morado
        fondoMorado,

        // círculos en el fondo
        Positioned(top: 120.0, left: 30.0, child: circulo),
        Positioned(top: 30.0, right: -10.0, child: circulo),
        Positioned(top: 50.0, right: 10.0, child: circulo),

        // ícono con nombre
        nombreConIcono,
        
      ],
    );




 }
}