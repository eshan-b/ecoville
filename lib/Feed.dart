import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoville/service/event_crud.dart';
import 'package:ecoville/service/event_model.dart';
import 'package:ecoville/service/user_crud.dart';
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

  /*
   * Since Dart await does not always wait, this is a workaround.
   * 1. Change event_model to have Future<UserModel> instead of UserModel
   * 2. The event.user which we thought would be resolved after await but it actually takes time to resolve.
   * 3. Set event.user = Future<UserModel> and let Event Card and Event Details await again until it is resolved.
   */
  Future<UserModel> _findLeadUser(EventModel event) async {
    UserModel user = await UserService().find(event.lead_user);
    return user;
  }

  findLeadUser(EventModel event) async {
    if (event.user == null) {
      event.user = _findLeadUser(event);
    }
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
              findLeadUser(event);
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
