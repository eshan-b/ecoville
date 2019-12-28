import 'package:flutter/material.dart';
import 'dart:io';

import 'service/comments.dart';
import 'service/event.dart';
import 'service/supplies.dart';

class EventDetail extends StatefulWidget {
  Event event;

  EventDetail({this.event});

  @override
  _EventDetailState createState() => _EventDetailState(event: this.event);
}

class _EventDetailState extends State<EventDetail> {
  Event event;
  List<Supplies> supplies;
  List<Comments> comments;

  _EventDetailState({this.event});

  @override 
  void initState()  {
      super.initState();
      this.getEventDetails();
  }

  void getEventDetails() {
    this.fetchEventDetails();
  }

  void fetchEventDetails() async {
    var supplyService = SuppliesService();
    this.supplies = await supplyService.find_all_supplies(event.event_id);
    var commentService = CommentsService();
    this.comments = await commentService.find_all_comments(event.event_id);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () => {
                    Navigator.pop(context)
                  },
                ),
                Text(
                  "Post Details", 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  )
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0)),
            ),
            child: ListView(
              primary: false,
              children: <Widget>[
                EventCard(event: event),
              ],
            )
          )
        ]
      )
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({
    Key key,
    this.event
  }) : super(key: key);

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
                      buildListTile(this.event), //List Tile: User, Date,
                      buildPostImage(this.event), //Actual Image of the Post
                      buildLikesView(this.event),
                    ]
                  )
                )
              ]
            )
          )
        )
      ]
    );
  }

  ListTile buildListTile(Event event) {
    return ListTile(
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
              image: AssetImage("lib/StockImages/ChillingFingersIcon.jpg"),
              fit: BoxFit.cover
            ),
          ),
        ),
      ),
      title: Text(
        "${event.name}",
        style: TextStyle(
          fontWeight: FontWeight.w700,
        )
      ),
      subtitle: Text("${event.lead_user} | ${event.posted_date}"),
      trailing: Icon(Icons.more_vert),
    );
  }

  Widget buildPostImage(Event event) {
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
            image: AssetImage("lib/StockImages/Mountain1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      );
  }

  Padding buildLikesView(Event event) {
    return Padding(
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
                      "${event.likes}",
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
                      "${event.dislikes}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                      )
                    )
                  ],
                ),

                SizedBox(width: 20),

                Row(children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.chat),
                    iconSize: 30.0,
                    onPressed: () => print('Comment post')
                  ),
                  Text(
                    "${event.comments_amt}",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600
                    )
                  )
                ])
              ],
            )
          ],
        )
      );
    }
}
