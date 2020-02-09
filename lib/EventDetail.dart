import 'package:ecoville/service/event_signup_crud.dart';
import 'package:ecoville/service/event_signup_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'CommentCardList.dart';
import 'BottomCommentBar.dart';
import 'SuppliesCard.dart';
import 'service/comment_crud.dart';
import 'service/event_model.dart';
import 'service/user_crud.dart';
import 'service/user_model.dart';
import 'service/comment_model.dart';


class EventDetail extends StatefulWidget {
  final UserModel currentUser;
  final EventModel event;

  EventDetail({this.currentUser, this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> with SingleTickerProviderStateMixin {
  Stream<List<CommentModel>> comments;
  UserModel leadUser;
  Set<Marker> markers = Set<Marker>();
  LatLng location;
  String address; //string version of address
  Position _currentPosition;
  double distanceInMeters;
  double distanceInMiles;
  EventSignupModel currentSignUp;
  
  @override
  void initState() {
    super.initState();
    this.comments = CommentService(widget.event.documentID).list();
    setLeadUser();
    this.getMarkers();
    findCurrentSignUp();
  }

  setLeadUser() async {
    UserModel user = await widget.event.user;
    setState(() {
      leadUser = user;
    });
  }

  bool isSignedUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              buildImage(),

              Container(
                height: 100,
                width: 50,
                color: Colors.grey.withOpacity(0.3), //keep for disabled
                margin: EdgeInsets.only(top: 170.0),
                child: FlatButton(
                  color: Colors.grey.withOpacity(0.3),
                  child: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    return Navigator.pop(context);
                  }, 
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 340.0),
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))
                ),
              ),
            ],
          ),
          buildTabs(),
          showIndexTab(),
        ],
      ),
      bottomNavigationBar: (selectedIndex == 1) ? BottomCommentBar(currentUser: widget.currentUser, event: widget.event) : Container(height: 0)
    );
  }

  RaisedButton buildSignupButton() {
    return RaisedButton(
      onPressed: () async {
        await SignupService(widget.event.documentID).create(
          EventSignupModel(signed_user: widget.currentUser.documentID)
        );
        findCurrentSignUp();
        setState(() {
          this.isSignedUp = true;  
        });
      },
      splashColor: Colors.green[600],
      color: Colors.green[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      highlightElevation: 1,

      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          'Sign-Up',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white 
          ),
        ),
      ),
    );
  }

  findCurrentSignUp() async {
    EventSignupModel signup = await SignupService(widget.event.documentID).findByField(fieldName: "signed_user", fieldValue: widget.currentUser.documentID);
    print("signup: $signup");
    this.isSignedUp = signup != null ? true : false;
    this.currentSignUp = signup;
  }

  RaisedButton buildUndoButton() {
    return RaisedButton(
      onPressed: () async {
        if (this.currentSignUp != null) {
          await SignupService(widget.event.documentID).delete(this.currentSignUp.documentID);
        }
        setState(() {
          this.isSignedUp = false;  
        });
      },
      splashColor: Colors.green[600],
      color: Colors.green[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 1,

      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          'Undo',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white 
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    return Container(
      width: double.infinity,
      height: 360.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 5),
            blurRadius: 8.0,
          ),
        ],

        image: DecorationImage(
          image: widget.event.photo != null ? NetworkImage(widget.event.photo) : AssetImage("lib/StockImages/Mountain1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  int selectedIndex = 0;
  final List<String> categories = ['About', "Comments", 'Supplies', 'Location'];

  Widget buildTabs() {
    return Container(
      height: 80,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: index == selectedIndex ? Colors.black : Colors.black45,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2, 
                      )
                    )
                  ),
                  index == selectedIndex ? Container(
                    height: 5,
                    width: 50,
                    color: Color.fromRGBO(53, 136, 86, 1),
                  ) :
                  Container(height: 0),
                ],
              ),
            )
          );
        }
      )
    );
  }

  Widget showIndexTab() {
    if (selectedIndex == 0) 
      return buildAbout();
    else if (selectedIndex == 1) 
      return Column(
        children: <Widget>[
          Container(
            height: 50, 
            color: Color.fromRGBO(153, 195, 169, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.info, color: Color.fromRGBO(18, 79, 42, 1)),
                SizedBox(width: 10),
                Text("Remember to be polite and constructive"),
              ],
            )
          ),
          SizedBox(height: 10),
          CommentCardList(event: widget.event, currentUser: widget.currentUser)
        ],
      );
    else if (selectedIndex == 2) 
      return SuppliesCard(event: widget.event);
    else 
      return buildLocation();
  }

  Widget buildAbout() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 20.0, bottom: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Posted on: ${DateFormat.yMd().add_jm().format(widget.event.posted_date.toDate())}"),
          Text("Event on: ${widget.event.event_date} | ${widget.event.event_time}"),
          SizedBox(height: 20),

          Text(
            widget.event.event_name,
            style: TextStyle(
              fontSize: 24
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Lorem Ipsum",
            style: TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(112, 112, 112, 1),
            ),
          ),

          SizedBox(height: 30),

          Text(
            "Event Leader",
            style: TextStyle(
              fontSize: 24
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      height: 50,
                      width: 50,
                      image: (leadUser != null && leadUser.photo_url != null) ? NetworkImage(leadUser.photo_url) : AssetImage('lib/StockImages/TreeUserIcon.png'),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  leadUser.display_name,
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 30),
          Text(
            "Volunteers",
            style: TextStyle(
              fontSize: 24
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Card buildUserCard() {
    return Card(
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Colors.black45, offset: Offset(0, 2), blurRadius: 6.0
              )
            ]
          ),

          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50,
                width: 50,
                image: (leadUser != null && leadUser.photo_url != null) ? NetworkImage(leadUser.photo_url) : AssetImage('lib/StockImages/TreeUserIcon.png'),
                fit: BoxFit.cover
              ),
            ),
          ),
        ),

        title:Text(leadUser.display_name)
      )
    );
  }

  setCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print("Current Location: $_currentPosition");
  }

  setLocationBetween() async {
    distanceInMeters = await Geolocator().distanceBetween(_currentPosition.latitude , _currentPosition.longitude, widget.event.location.latitude, widget.event.location.longitude);
    print("Distance in meters: $distanceInMeters");
    distanceInMiles = (distanceInMeters*0.000621371).roundToDouble();
    print("Distance in miles: $distanceInMiles");
  }

  getMarkers() async {
    this.location = LatLng(widget.event.location.latitude, widget.event.location.longitude);
    
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(widget.event.location.latitude, widget.event.location.longitude);
    if (placemarks != null) {
      address = "${placemarks[0].name} ${placemarks[0].thoroughfare}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}";
      print(address);
    }

    final Marker marker = Marker(
      markerId: MarkerId("1"),
      position: this.location,
      infoWindow: InfoWindow(title: address),
    );

    setState(() {
      this.markers.add(marker);  
    });

    await setCurrentLocation();
    await setLocationBetween();
  }

  Widget buildLocation() {
    return Container(
      width: double.infinity,
      height: 300,
      child: Stack(
        children: <Widget> [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: this.location,
              zoom: 15.0
            ),
            markers: markers,
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column( //Just put in a column because of MainAxisAlignment
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          offset: Offset(0, 2),
                          blurRadius: 6.0
                        )
                      ],
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width - 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget> [
                        Text(address),
                        Text('$distanceInMiles miles away from you')
                      ]
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}
