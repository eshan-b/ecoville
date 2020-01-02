import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:place_picker/place_picker.dart';

import 'HomeScreen.dart';
import 'service/event_crud.dart';
import 'service/event_model.dart';
import 'service/user_model.dart';

class EnterLocation extends StatefulWidget {
  EventModel _eventModelObject;
  final UserModel currentUser;
  EnterLocation(this._eventModelObject, this.currentUser);

  @override
  _EnterLocationState createState() => _EnterLocationState();
}

class _EnterLocationState extends State<EnterLocation> {
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

  Future<void> _createEvent(BuildContext context) async {
    widget._eventModelObject.location = eventLocationController.text;
    widget._eventModelObject.lead_user = widget.currentUser.documentID;
    print(widget._eventModelObject.toJson());
    //if (widget._eventModelObject == null) {
      /*Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Processing...')));*/
      await EventService().create(widget._eventModelObject);
    /*} else {
      Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Event already exists')));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Location'),
      ),

      body: Column(
        children: <Widget>[
          Padding(
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

          SizedBox(height: 20),

          RaisedButton(
            onPressed: () async {
              await _createEvent(context);

              return Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(currentUser: widget.currentUser))
              );
            },
            color: Colors.green[200],
            splashColor: Colors.green[600],
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 1,
            child: Row(
              children: <Widget>[
                Text("Submit"),
                Icon(Icons.done)
              ]
            )
          ),
        ] 
      )
    );
  }
}
