import 'package:flutter/material.dart';

import 'CommentCardList.dart';
import 'BottomCommentBar.dart';
import 'SuppliesCard.dart';
import 'service/comment_crud.dart';
import 'service/event_model.dart';
import 'service/user_model.dart';
import 'service/comment_model.dart';
import 'util/EventCard.dart';


class EventDetail extends StatefulWidget {
  final UserModel currentUser;
  final EventModel event;

  EventDetail({this.currentUser, this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Stream<List<CommentModel>> comments;
  
  @override
  void initState() {
    super.initState();
    this.comments = CommentService(widget.event.documentID).list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body:  ListView(
        children: <Widget>[
          buildHeader(context),
          EventCard(currentUser: widget.currentUser, event: widget.event),
          SuppliesCard(event: widget.event),
          CommentCardList(event: widget.event)
        ]
      ),
      bottomNavigationBar: BottomCommentBar(currentUser: widget.currentUser, event: widget.event)
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
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
    );
  }
  
}
