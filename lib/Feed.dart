import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoville/service/user.dart';

import 'EventDetail.dart';
import 'util/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'service/event.dart';
import 'dart:async';

class FeedWidget extends StatefulWidget {
  var currentUser;

  FeedWidget(this.currentUser);

  //Information for the feeds
  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  CollectionReference events = Firestore.instance.collection("events");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: events.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              var event = snapshot.data.documents[index];
              return InkWell(
                onTap: () => {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => EventDetail(currentUser: widget.currentUser, event: event))
                  )
                },
                child: EventCard(currentUser: widget.currentUser, event: event)
              );
            }
          );
        } else if(snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.warning,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 40),
                Text("Whoops!, Something went wrong!")
              ],
            )
          );
        } else {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: <Widget>[
                SpinKitPouringHourglass(
                  color: Colors.grey,
                  size: 50.0,
                ),
                SizedBox(height: 40),
                Text("Give me a sec...")
              ],
            )
          );
        }
      }
    );
  }
}
