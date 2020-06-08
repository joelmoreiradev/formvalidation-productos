import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class ProductosProvider {

   //url principal que será usada en las funciones / métodos para hacer distintas peticiones
  final String _url = 'https://flutter-varios-eefbe.firebaseio.com';

  // instancia de mis preferencias de usuario, donde se guarda el token de firebase.
  final _prefs = new PreferenciasUsuario();


  // función crearProducto
  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

                         // post requiere la url, y lo que voy a postear.
    //al hacer post de (producto), estoy posteando todas las variables que tengan datos de ProductoModel.
    final resp = await http.post( url, body: productoModelToJson(producto) );
    
    final decodedData = json.decode(resp.body);

    print('respuesta de firebase: $decodedData');

    // esto es solo para cumplir la condición de que la función retorna un boolean.
    return true;

  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

                         // post requiere la url, y lo que voy a postear.
    //al hacer post de (producto), estoy posteando todas las variables que tengan datos de ProductoModel.
    final resp = await http.put( url, body: productoModelToJson(producto) );
    
    final decodedData = json.decode(resp.body);

    print('respuesta de firebase: $decodedData');

    // esto es solo para cumplir la condición de que la función retorna un boolean.
    return true;

  }

  Future<List<ProductoModel>> cargarProductos() async {

    //defino la url donde están los productos
    final url = '$_url/productos.json?auth=${_prefs.token}';

    //hago una petición http y guardo la respuesta en la variable resp
    final resp = await http.get(url);

    //decodifico el body de la respuesta y lo guardo en un mapa llamado decodedData
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    // print('la respuesta es $resp');
    // print('decodedData es $decodedData');

    
    
    if( decodedData == null ) return [];

    // "barrer" el decodedData (recorro el mapa)
    // con esto lo que hago es poder tener por separado las id, del contenido del producto
    decodedData.forEach((id, prod){
      // print(id);
      // print(prod);

      // paso los datos en formato json de los productos a un mapa
      final prodTemp = ProductoModel.fromJson(prod);

      //como la id no está en prod y la quiero guardar también en prodTemp, uso prodTemp.id = id;
      prodTemp.id = id;

      // agrego el producto temporal a la lista productos
      productos.add(prodTemp);

    });


     print(productos);

     // esta sería la forma de acceder a una propiedad específica de un producto, [0] es el primer producto, y .id me dará la id de ese primer producto.
     print(productos[0].id);

     // regreso el listado de productos
    return productos;

  }


  Future<int> borrarProducto (String id) async {

    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    //esto simplemente para cumplir la condición de que la función retorna un entero.
    return 1;

  }


  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dzbtf1rpi/image/upload?upload_preset=iqrmdkiw');
    final mimeType = mime(imagen.path).split('/'); // image/jpg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
       url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
       imagen.path,
       contentType: MediaType( mimeType[0], mimeType[1]) // tipo y subtipo ( image/jpg)
    );

    imageUploadRequest.files.add(file); // adjunto el archivo

    final streamResponse = await imageUploadRequest.send(); // enviar petición y guardar respuesta en streamResponse
    final resp = await http.Response.fromStream(streamResponse);
    
    // si hay error
    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salió mal');
      print(resp.body);
      return null;
    }


    final respData = json.decode(resp.body);
    print(respData);
    return respData['secure_url'];
  }

}