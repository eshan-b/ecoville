import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../service/event_model.dart';
import '../service/user_crud.dart';
import '../service/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class EventCard extends StatefulWidget {
  final EventModel event;
  final UserModel currentUser;

  const EventCard({
    Key key,
    this.currentUser,
    this.event,
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  UserModel leadUser;

  @override
  void initState() {
    super.initState();
    findLeadUser();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[ 
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Container(
            width: double.infinity, //sets width to full page
            height: 620.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.grey[400],
                  Colors.grey[300],
                  Colors.grey[200],
                  Colors.grey[100],
                ],
              ),
              borderRadius: BorderRadius.circular(25.0)
            ),

            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: <Widget>[
                      eventTile, //List Tile: User, Date,
                      eventImage, //Actual Image of the Post
                      eventRatings,
                    ]
                  )
                )
              ]
            ),
          )
        )
      ]
    );
  }

  Widget get eventTile => ListTile(
    leading: Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Colors.black45, offset: Offset(0, 2), blurRadius: 6.0
        )
      ]),
    child: CircleAvatar(
        child: ClipOval(
          child: Image(
            height: 50,
            width: 50,
            image: (leadUser != null && leadUser.photo_url != null) ? NetworkImage(leadUser.photo_url) : AssetImage('lib/StockImages/ChillingFingersIcon.jpg'),
            fit: BoxFit.cover
          ),
        ),
      ),
    ),
    title: Text(
      widget.event.event_name,
      style: TextStyle(
        fontWeight: FontWeight.w700,
      )
    ),
    subtitle: Text(leadUser != null ? "${leadUser.display_name} | ${DateFormat.yMd().add_jm().format(widget.event.posted_date.toDate())}" : "Invalid User | ${DateFormat.yMd().add_jm().format(widget.event.posted_date.toDate())}"),
    trailing: Icon(Icons.more_vert),
  );
        

  Widget get eventImage => Container(
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

  Widget get eventRatings => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  iconSize: 30,
                  onPressed: () => print('Like post')
                ),
                Text(
                  "${widget.event.likes}",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600
                  )
                )
              ],
            ),

            SizedBox(width: 20.0),

            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_down),
                  iconSize: 30,
                  onPressed: () => print('Dislike post')
                ),
                Text(
                  "${widget.event.dislikes}",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600
                  )
                )
              ],
            ),

            SizedBox(width: 20),

            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.chat),
                  iconSize: 30.0,
                  onPressed: () => print('Comment post')
                ),
                Text(
                  "${widget.event.comments_amt}",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600
                  )
                )
              ]
            )
          ],
        )
      ],
    )
  );
}
