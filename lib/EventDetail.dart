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
  EventSignupModel currentSignUp;
  
  @override
  void initState() {
    super.initState();
    this.comments = CommentService(widget.event.documentID).list();
    this.leadUser = widget.event.user;
    //findLeadUser();
    this.getMarkers();
    findCurrentSignUp();
  }

  findLeadUser() async {
    print("Event in the eventCard: ${widget.event.toJson()}");
    UserModel user =  await UserService().find(widget.event.lead_user);
    if (mounted) {
      setState(() {
        this.leadUser = user;
      });
    }
  }

  bool isSignedUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            Text(widget.event.event_name),
            if(isSignedUp == false) buildSignupButton() else buildUndoButton(),
          ]
        ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => {
            Navigator.pop(context)
          },
        ),
      ),

      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),

          buildImage(),

          SizedBox(height: 20),

          buildTabs(),

          //SizedBox(height: 20),

          showIndexTab()
        ],
      ),
      bottomNavigationBar: BottomCommentBar(currentUser: widget.currentUser, event: widget.event)
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      height: 360.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 5),
            blurRadius: 8.0,
          ),
        ],

        image: DecorationImage(
          image: widget.event.photo != null ? NetworkImage(widget.event.photo) : AssetImage("lib/StockImages/Mountain1.jpg"), // TBD: change it to uploaded image
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  int selectedIndex = 0;
  final List<String> categories = ['About', "Comments", 'Supplies', 'Location'];

  Widget buildTabs() {
    return Container(
      height: 60,
      color: Colors.green[300],
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
              padding: EdgeInsets.symmetric(horizontal: 60/3,vertical: 60/4),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: index == selectedIndex ? Colors.white : Colors.white60,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                )
              )
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
      return CommentCardList(event: widget.event, currentUser: widget.currentUser);
    else if (selectedIndex == 2) 
      return SuppliesCard(event: widget.event);
    else 
      return buildLocation();
  }

  Widget buildAbout() {
    return Column(
      children: <Widget>[
        buildUserCard(),
        Text("Posted on: ${DateFormat.yMd().add_jm().format(widget.event.posted_date.toDate())}"),
        Text("Event on: ${widget.event.event_date} | ${widget.event.event_time}")
      ],
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

  getMarkers() async {
    this.location = LatLng(widget.event.location.latitude, widget.event.location.longitude);
    String address;
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(widget.event.location.latitude, widget.event.location.longitude);
    if (placemarks != null) {
      address = "${placemarks[0].name} ${placemarks[0].thoroughfare}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}";
      print(address);
    }

    final Marker marker = Marker(
      markerId: MarkerId("1"),
      position: this.location,
      infoWindow: InfoWindow(title: address)
    );

    setState(() {
      this.markers.add(marker);  
    });
    
  }

  Widget buildLocation() {
    return Container(
      width: double.infinity,
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: this.location,
          zoom: 15.0
        ),
        markers: markers,
      )
    );
  }

}
