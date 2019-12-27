import 'package:ecoville/Feed.dart';
import 'package:ecoville/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:ecoville/HomeScreen.dart';

//import 'LoginScreen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Eshi App", 
      home: LoginScreen(),
      
      theme: ThemeData(
        primaryColor: Color.fromRGBO(73, 90, 22, 1),
        accentColor: Colors.green[400],
        fontFamily: 'OpenSans'
      )
    ),
  );
}
