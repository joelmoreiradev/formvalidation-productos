import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();

  // key que identificará al scaffold donde mostraré el snackbar
  final scaffoldKey = GlobalKey<ScaffoldState>();


  bool _guardando = false;

  File foto;

  // instancia de ProductosProvider
  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {

    // recibo los argumentos que son enviados al tocar un ListTile del home, y los guardo en ProdData.
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    
    // si prodData tiene datos, producto va a ser igual a prodData.
    if(prodData != null){
      producto = prodData;
    }

    return Scaffold(

      //key para identificar al scaffold y mostrar un snackbar en el.
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
           IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          //bordes de 15px para todo lo que esté dentro del container
          padding: EdgeInsets.all(15.0),

          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ), //fin de Form


        ),
      ),
    );
  }

  Widget _crearNombre(){

    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
        
      ),

      // este onSaved se ejecuta únicamente DESPUÉS de que la información es validada por el validator.
      onSaved: (value) => producto.titulo = value,
      
      // validación de formulario.
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }

      },
      
    );

  }

 Widget _crearPrecio(){
   return TextFormField(
     initialValue: producto.valor.toString(),
     keyboardType: TextInputType.numberWithOptions(decimal: true),
     decoration: InputDecoration(
       labelText: 'Precio',

     ),
     // este onSaved se ejecuta DESPUÉS de que la información es validada por el validator.
     onSaved: (value) => producto.valor = double.parse(value),

       // value es el valor que recibo del TextFormField.
      validator: (value){
        // si el valor es un número no retorno nada, ya que está bien
        if (utils.isNumeric(value)){
          return null;
        } 
        // si el valor no es un número, retorno 'ingrese un número válido porfavor'.
        else {
          return 'ingrese un número válido porfavor';
        }
      },

   );

  }

 Widget _crearDisponible(){
   return SwitchListTile(
     value: producto.disponible,
     title: Text('Disponible'),
     onChanged: (value) => setState((){
       producto.disponible = value;
     }),
   );
 }

 Widget _crearBoton(){
   return RaisedButton.icon(
      
     icon: Icon(Icons.save), 
     label: Text('Guardar'),
     color: Colors.deepPurple,
     textColor: Colors.white,

     // si _guardando es igual a true, el botón va a retornar null, caso contrario ejecuto _submit.
     onPressed: (_guardando == true) ? null : _submit,
    );
 }

 void _submit()async{

  

  // esto se ejecutará si el formulario no es válido.
  if( !formKey.currentState.validate() ) return;
  print('valido');
   // si es válido se ejecutará todo el código que sigue después
  
  // cambio el valor de _guardando a true, y redibujo el widget.
  setState(() {
    _guardando = true;
  });

  // si hay una imágen seleccionada por procesarImagen, subirla a Cloudinary,
  // y guardar la respuesta (url) en producto.fotoUrl para subirla a Firebase.
  if(foto != null){
    producto.fotoUrl = await productoProvider.subirImagen(foto);
  }
  
  
  //esto dispara el save de todos los TextFormField que estén dentro del formulario
  formKey.currentState.save();

  
  if (producto.id == null){
    productoProvider.crearProducto(producto);
  } else {
    productoProvider.editarProducto(producto);
    
  }
  
  

  mostrarSnackbar('Registro guardado');
  
  // cerrar página producto / volver a HomePage.
  // Navigator.pop(context);

  setState(() {
    
  });

 }



  void mostrarSnackbar(String mensaje){

    final snackbar = SnackBar(  
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Colors.green,
    );

    
    
    scaffoldKey.currentState.showSnackBar(snackbar);

    

  }


 Widget _mostrarFoto(){
    // si hay contenido en fotoUrl...
    if (producto.fotoUrl != null){
      // si producto tiene fotoUrl, retorno un Container con una imágen de red.
      return Container( 
        child: FadeInImage(
        // si foto tiene un valor, toma el path, si no tiene un valor muestra no-image.png
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
        
        ),
      );

    } else {
      // de lo contrario si no hay imágen muestro no-image.png
      return Image(
        // si foto tiene un valor, toma el path, si no tiene un valor muestra no-image.png
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  } 
  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);

  }


// elegir o tomar una foto y guardarla en la variable foto de tipo File
  _procesarImagen(ImageSource origen)async{

    foto = await ImagePicker.pickImage( 
      source: origen,
      imageQuality: 100
    );

      if(foto != null) {
        //limpieza
        producto.fotoUrl = null; // borro el url de la foto anterior para que fotoUrl sea null y pueda mostrar una nueva foto.
      }

      setState(() {});

  }
  






}