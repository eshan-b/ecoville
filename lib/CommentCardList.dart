import 'package:flutter/material.dart';

import 'CommentCard.dart';
import 'service/comment_crud.dart';
import 'service/comment_model.dart';
import 'service/event_model.dart';
import 'service/user_model.dart';

class CommentCardList extends StatefulWidget {
  final EventModel event;
  final UserModel currentUser;

  const CommentCardList({
    Key key, 
    this.event, 
    this.currentUser
  }) : super(key: key);
  
  @override
  _CommentCardListState createState() => _CommentCardListState();
}

class _CommentCardListState extends State<CommentCardList> {
  Stream<List<CommentModel>> comments;
  
  @override
  void initState() {
    super.initState();
    this.comments = CommentService(widget.event.documentID).list();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentModel>> (
    stream: comments,
    builder: (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot) {
      print("Comments - FutureBuilder is called with snapshot: ${snapshot.connectionState}");
      if (snapshot.hasData) {
        print("Comments  - Number of items in Snapshot.data.documents: ${snapshot.data.length}");
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            CommentModel comment = snapshot.data[index];
            return CommentCard(comment: comment, currentUser: widget.currentUser);
          }
        );
      } else if(snapshot.hasError) {
        return Text("Error: Unable to load comments, error= ${snapshot.error}");
      } else {
        return Text("Loading comments...");
      }
    }
  );
  }
}
