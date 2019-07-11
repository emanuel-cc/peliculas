import 'package:flutter/material.dart';

// archivos personalizados
import 'package:peliculas/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MovieApp',
      initialRoute: '/',
      routes: {
        '/'     : (BuildContext context)=>HomePage(),
      },
    );
  }
}