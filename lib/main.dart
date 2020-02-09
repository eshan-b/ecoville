import 'package:flutter/material.dart';
import 'LoginScreen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Eshi App", 
      home: LoginScreen(),
      
      theme: ThemeData(
        primaryColor: Color.fromRGBO(53, 136, 86, 1),//HexColor("#358856"),
        fontFamily: 'OpenSans'
      )
    ),
  );
}
