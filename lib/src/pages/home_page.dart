import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';

/* TODO: Hacer que automáticamente luego de haber creado o editado un item 
  se actualice la pantalla home para que los items nuevos o editados sean visibles*/


class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = new ProductosProvider();


  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);
   
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Home'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.refresh), onPressed: (){
        //       // redibujo los widgets
        //       setState(() {});
        //       print('update');
        //     }
        //   ),
        // ],
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
      
    );
  }

  Widget _crearListado(){
   
    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if( snapshot.hasData ){

         final productos = snapshot.data;
         

          return ListView.builder(
            //cantidad de veces que la función de itemBuilder será llamada / ejecutada.
            itemCount: productos.length,

            // crear los items
            itemBuilder: (context, i) {
              

              // productos[i] todavía no entiendo por que se envía
              return _crearItem(context, productos[i]); 
            } 
            
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    
  }

  Widget _crearItem(BuildContext context, ProductoModel producto){

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion){
         // TODO: Borrar producto en la base de datos
         productosProvider.borrarProducto(producto.id);
         setState(() {});
         
         
      },

      child: Card(
        child: Column(
          children: <Widget>[ 
            (producto.fotoUrl == null )
             ? Image(image: AssetImage('assets/no-image.png'),) // si no hay foto
             : FadeInImage(                                     // si hay foto.
               image: NetworkImage(producto.fotoUrl),
               placeholder: AssetImage('assets/jar-loading.gif'),
               height: 300.0,
               width: double.infinity,
               fit: BoxFit.cover,
             ),

          ListTile(
           title: Text('${producto.titulo} - ${producto.valor}'),
           subtitle: Text(producto.id),
           onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto)
           .then((value) {
             setState((){});
          }),
        
       ),


          ], 
        ),
      )
    );


    


  }

  _crearBoton(context) {
    
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: (){

        /* redibujo los widgets de la pantalla home antes de ir a productos para no tener el error de 
        "A dissmissed Dismissible widget is still part of the tree." al regresar luego de haber borrado un item. */
        

        // navego a la pantalla ProductoPage
        Navigator.pushNamed(context, 'producto')
          .then((value) {       //esto es para actualizar la pantalla home al volver desde producto.
               setState(() {});
           });
           

        
      }
      //navego a la pantalla de agregar o editar producto
        
        
        
    );

  }

}