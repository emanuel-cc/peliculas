import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider{
  String _apikey='25d31599243ac9c6e9dd94435ea96737';
  String _url='api.themoviedb.org';
  String _language='es-ES';

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    //Llamamos a la petición http con la url con la respuesta
  final resp = await http.get(url);

  // Decodificamos la respuesta recibida via http anterior de la variable resp
  final decodedData = json.decode(resp.body);

  //Obtenemos las peliculas, transformamos la respuesta en peliculas
  final peliculas = new Peliculas.fromJsonList(decodedData['results']);
  //print(decodedData);
  print(peliculas.items[0].title);
  return peliculas.items;
  }

 Future<List<Pelicula>> getEnCines() async{

   // Generar url
   final url = Uri.https(_url, '3/movie/now_playing',{
     'api_key'  : _apikey,
     'language' : _language
   });
  
  // Llamamos al método que nos permite procesar la informacion de un json
  return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    //Generar url
    final url = Uri.https(_url,'3/movie/popular',{
      'api_key' : _apikey,
      'language' : _language
    });
    // Llamamos al método que nos permite procesar la informacion de un json
    return await _procesarRespuesta(url);
  }
}