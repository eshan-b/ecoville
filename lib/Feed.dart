import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoville/service/event_crud.dart';
import 'package:ecoville/service/event_model.dart';
import 'service/user_model.dart';

import 'EventDetail.dart';
import 'util/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

class FeedWidget extends StatefulWidget {
  final UserModel currentUser;

  FeedWidget(this.currentUser);

  //Information for the feeds
  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  Stream<List<EventModel>> events;

  @override
  void initState() {
    super.initState();
    this.events = EventService().list();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventModel>>(
      stream: events,
      builder: (BuildContext context, AsyncSnapshot<List<EventModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              EventModel event = snapshot.data[index];
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
