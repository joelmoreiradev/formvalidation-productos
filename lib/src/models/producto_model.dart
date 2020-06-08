// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';


/// esto son dos funciones para decodificar y codificar a Json, las necesitaré al hacer peticiones http. ///
// DECODIFICAR DE JSON
ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

//Recibo los datos guardados en las propiedades de la clase ProductoModel, y los codifico a json.
String productoModelToJson(ProductoModel data) => json.encode(data.toJson());


// Esta es la clase del modelo.
class ProductoModel {
    String id;
    String titulo;
    double valor;
    bool disponible;
    String fotoUrl;

    ProductoModel({
        this.id,
        this.titulo = '',
        this.valor = 0.0,
        this.disponible = true,
        this.fotoUrl,
    });

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"],
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
    };
}
