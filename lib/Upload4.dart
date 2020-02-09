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
  TextEditingController _addressController;
  bool _validate = false;

  Future<void> _createEvent(BuildContext context) async {
    widget._eventModelObject.lead_user = widget.currentUser.documentID;
    print(widget._eventModelObject.toJson());
      await EventService().create(widget._eventModelObject);
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    //comment something don't delete
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Event Location'),
            buildSubmitButton(),
          ],
        )
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
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                margin: EdgeInsets.only(top: 100.0),
                child: buildUseCurrentButton(snapshot.data.latitude, snapshot.data.longitude),
              ),
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
          controller: _addressController,
          decoration: InputDecoration(
            errorText: _validate ? 'Value Can\'t Be Empty' : null,
            hintText: 'Enter Address',
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                await searchandNavigate();
                FocusScope.of(context).unfocus();
              },
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
            setState(() {
              _addressController.text.isEmpty ? _validate = true : _validate = false;
            });
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
              SizedBox(width: 5),
              Icon(Icons.done)
            ]
          )
        ),
      ],
    );
  }

  Widget buildUseCurrentButton(currentLat, currentLong) {
    return RaisedButton(
      color: Colors.green[200],
      splashColor: Colors.green[600],
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      highlightElevation: 1,
      child: Row(
        children: <Widget>[
          Icon(Icons.gps_fixed),
          SizedBox(width: 5),
          Text("Use Current Location"),
        ]
      ),
      onPressed: () async {
        widget._eventModelObject.location = GeoPoint(currentLat, currentLong);
        await _createEvent(context);

        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(currentUser: widget.currentUser))
        );
      }
    );
  }
}
