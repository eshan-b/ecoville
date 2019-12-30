import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:place_picker/place_picker.dart';

class enterLocation extends StatefulWidget {
  var _eventModelObject;
  enterLocation(this._eventModelObject);

  @override
  _enterLocationState createState() => _enterLocationState();
}

class _enterLocationState extends State<enterLocation> {
  /*void showPlacePicker() async {
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
  }*/

  final eventLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Location'),
      ),

      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
          child: TextFormField(
            controller: eventLocationController,

            decoration: InputDecoration(
              labelText: 'Where does your project take place?'
            ),

            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      )
    );
  }
}
