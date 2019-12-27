import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:place_picker/place_picker.dart';

class showMap extends StatefulWidget {
  @override
  _showMapState createState() => _showMapState();
}

class _showMapState extends State<showMap> {
  void showPlacePicker() async {
    var customLocation; //will fix later
        LocationResult result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
              PlacePicker(
                "AIzaSyD4h3fys-6wyZKeKHsYccFmyN6qKbG5pjA",
                displayLocation: customLocation,
            )
      )
    );

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
