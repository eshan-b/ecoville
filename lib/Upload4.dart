import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'dart:async';

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
  Future<Position> _currentPosition;
  GoogleMapController mapController;

  String searchAddr;

  Future<void> _createEvent(BuildContext context) async {
    widget._eventModelObject.lead_user = widget.currentUser.documentID;
    //widget._eventModelObject.location = mapController.getLatLng(screenCoordinate);
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
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    /*if(mounted) {
      setState(() {
        _currentPosition = position;
        print("Got location: $_currentPosition");
      });
    }*/
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  searchandNavigate() async {
    try {
      print("Searching the address...");
      List<Placemark> result = await Geolocator().placemarkFromAddress(searchAddr);
      print("Changing camera position to lat: ${result[0].position.latitude}, long: ${result[0].position.longitude}");
      if (result != null) {
        widget._eventModelObject.location = GeoPoint(result[0].position.latitude, result[0].position.longitude);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                LatLng(result[0].position.latitude, result[0].position.longitude),
              zoom: 10.0
            )
          )
        );
      }
    } catch(error) {
      print("Error in search: ${error.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Location'),
      ),

      body: FutureBuilder<Position>(
        future: _currentPosition,
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (!snapshot.hasData) return Text("Getting device location...");
          return Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                  zoom: 15.0
                ),
                onMapCreated: onMapCreated,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
              ),

              buildEnterAddress(),

              buildSubmitButton()
            ],
          );
        }
        )
      
    );
  }

  Widget buildEnterAddress() {
    return Positioned(
      top: 30.0, right: 15.0, left: 15.0,
      child: Container(
        height: 50.0,
        width: double.infinity,
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), 
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 5.0),
              blurRadius: 10,
              spreadRadius: 3
            )
          ],
        ),

        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter Address',
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {await searchandNavigate();},
              iconSize: 30.0
            )
          ),

          onChanged: (val) {
            setState(() {
              searchAddr = val;
            });
          },

        )
      )
    );
  }

  Widget buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          onPressed: () async {
            await searchandNavigate();
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
      ],
    );
  }

}

/*Column(
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
)*/
