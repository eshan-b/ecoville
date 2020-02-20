import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset : false, //prevents overflow
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(53, 136, 86, 1),
          ), 
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        centerTitle: true,
        title: Text(
          "Location",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(53, 136, 86, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(53, 136, 86, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(53, 136, 86, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 30,
                width: 12,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(53, 136, 86, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),

      body: FutureBuilder<Position>(
        future: _currentPosition,
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (!snapshot.hasData) return Text("Getting device location...");
          return Column(
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildSubmitButton(),
                  SizedBox(width: 10),
                  buildUseCurrentButton(snapshot.data.latitude, snapshot.data.longitude)
                ],
              ),
              SizedBox(height: 20),
              buildEnterAddress(),
              Container(
                height: MediaQuery.of(context).size.height - 258,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 15.0
                  ),
                  onMapCreated: onMapCreated,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildEnterAddress() {
    return Container(
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

      child: PlacesAutocompleteFormField(
        apiKey: "AIzaSyDYDvp6jmjkieiFsDs5XE5HzRVtUvkRiZ4",
        mode: Mode.overlay,
        onError: onError,
        controller: _addressController,
        hint: "Enter Address",
        trailing: Icon(Icons.search),
        trailingOnTap: () async {
          if (_addressController != null) {
            FocusScope.of(context).unfocus();
            return await searchandNavigate();
          } else {
            FocusScope.of(context).unfocus();
            return SnackBar(content: Text("Please enter a location"));
          }
        },
        inputDecoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),
        onSaved: (val) {
          setState(() {
            searchAddr = val;
          });
        },
      ),
    );
  }

  void onError(PlacesAutocompleteResponse response) {
    print("Autocomplete Error: " + response.errorMessage);
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
