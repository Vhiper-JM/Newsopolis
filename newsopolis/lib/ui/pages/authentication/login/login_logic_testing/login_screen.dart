// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Esto seria la aplicacion de prueba'),
        ),
        body:Center(
          child: Text('Bienvenido a la aplicacion')  
          
        ) 
          
        
      ),
    );
  }
}