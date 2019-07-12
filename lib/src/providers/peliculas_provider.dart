import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider{
  String _apikey='25d31599243ac9c6e9dd94435ea96737';
  String _url='api.themoviedb.org';
  String _language='es-ES';

  // Nueva propiedad
  int _popularesPage = 0;
  bool _cargando=false;

  // 
  List<Pelicula> _populares = new List();

  // Creamos un stream, una tuberia
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  // Sink para añadir información, es decir peliculas
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  // Escuchar las peliculas
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  // Cerrar un Stream
  void disposeStreams(){
    _popularesStreamController?.close();
  }

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
    if(_cargando) return [];
        _cargando=true;
    // Lo incrementamos en uno
    _popularesPage++;

    //Generar url
    final url = Uri.https(_url,'3/movie/popular',{
      'api_key' : _apikey,
      'language' : _language,
      // agregamos uno nuevo
      'page'     : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);

    popularesSink(_populares);

    _cargando=false;
    return resp;
    // Llamamos al método que nos permite procesar la informacion de un json
    //return await _procesarRespuesta(url);
  }

  Future<List<Actor>> getCast(String peliId) async{
    final url = Uri.https(_url,'3/movie/$peliId/credits',{
      'api_key' : _apikey,
      'language' : _language
    });

    final resp = await http.get(url);
    final decodedData=json.decode(resp.body);

    final cast=new Cast.fromJsonList(decodedData['cast']);

    return cast.actores; // regresa los actores
  }
}