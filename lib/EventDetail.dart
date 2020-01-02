import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

import 'service/event_model.dart';
import 'service/user_crud.dart';
import 'service/user_model.dart';
import 'util/EventCard.dart';

import 'package:expand_widget/expand_widget.dart'; //for expand text (readMore)

import 'util/read_more_text.dart';

class EventDetail extends StatefulWidget {
  final UserModel currentUser;
  final EventModel event;

  EventDetail({this.currentUser, this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Query get comments => Firestore.instance.collection("comments").where("event_id", isEqualTo: widget.event.documentID);
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body:  ListView(
        children: <Widget>[
          buildHeader(context),

          //SizedBox(height: 10),

          
          EventCard(currentUser: widget.currentUser, event: widget.event),

          //SizedBox(height: 20),

          //SuppliesCard(event: widget.event, supplies: supplies),

          //SizedBox(height: 20),

          //CommentsCard(event: widget.event, comments: comments),
          commentCard
        ]
      ),

      bottomNavigationBar: BottomCommentBar(currentUser: widget.currentUser)
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

  Widget get commentCard => StreamBuilder<QuerySnapshot> (
      stream: comments.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print("Comments - FutureBuilder is called with snapshot: ${snapshot.connectionState}");
        if (snapshot.hasData) {
          print("Comments  - Number of items in Snapshot.data.documents: ${snapshot.data.documents.length}");
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var comment = snapshot.data.documents[index];
              return commentTile(comment);
            }
          );
        } else if(snapshot.hasError) {
          return Text("Error: Unable to load comments, error= ${snapshot.error}");
        } else {
          return Text("Loading comments...");
        }
      }
  );

  findPostedByUser(var userId) async {
    return await UserService().find(userId);
  }
  Widget commentTile(var comment) {
    UserModel user = findPostedByUser(comment['user_id']);
    return ListTile(
          leading: CircleAvatar(
              child: ClipOval(
                child: Image(
                  height: 50.0,
                  width: 50.0,
                  image: (user != null && user.photo_url != null) ? NetworkImage(user.photo_url) : AssetImage('lib/StockImages/Tree_User_Icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          title: Text(
            user != null && user.display_name != null ? user.display_name : "Invalid User",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(comment['message']),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite_border,
            ),
            color: Colors.grey,
            onPressed: () => print('Like comment'),
          ),
        );
  }
  
}

class BottomCommentBar extends StatelessWidget {
  final UserModel currentUser;

  const BottomCommentBar({
    Key key,
    this.currentUser,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.all(20.0),
              hintText: 'Add a comment',
              prefixIcon: Container(
                margin: EdgeInsets.all(4.0),
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      height: 48.0,
                      width: 48.0,
                      image: currentUser.photo_url != null ? NetworkImage(currentUser.photo_url) : AssetImage('lib/StockImages/Tree_User_Icon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              suffixIcon: Container(
                margin: EdgeInsets.only(right: 4.0),
                width: 70.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Color(0xFF23B66F),
                  onPressed: () => print('Post comment'),
                  child: Icon(
                    Icons.send,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}

class CommentsCard extends StatefulWidget {
  final EventModel event;
  final CollectionReference comments;

  const CommentsCard({
    Key key,
    @required this.event,
    this.comments,
  }) : super(key: key);

  @override
  _CommentsCardState createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.all(10),
          child: Container(
            width: double.infinity, //sets width to full page
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
              borderRadius: BorderRadius.circular(25.0),
            ),

            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: StreamBuilder<QuerySnapshot> (
                stream: widget.comments.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print("Comments - FutureBuilder is called with snapshot: ${snapshot.connectionState}");
                  if (snapshot.hasData) {
                    print("Comments  - Number of items in Snapshot.data.documents: ${snapshot.data.documents.length}");
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return BuildComment(comment: snapshot.data.documents[index]);
                      }
                    );
                  } else if(snapshot.hasError) {
                    return Text("Error: Unable to load comments, error= ${snapshot.error}");
                  } else {
                    return Text("Loading comments...");
                  }
                }
              )
            )
          ),
        )
      ],
    );
  }
}

class BuildComment extends StatefulWidget {
  final comment;
  
  const BuildComment({
    Key key,
    @required this.comment
  }) : super(key: key);

  @override
  _BuildCommentState createState() => _BuildCommentState();
}

class _BuildCommentState extends State<BuildComment> {
  UserModel postedByUser; 

  @override
  void initState() {
    super.initState();
    findPostedBy();
  }

  Future findPostedBy() async {
    this.postedByUser = await UserService().find(widget.comment['user_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: (postedByUser != null && postedByUser.photo_url != null) ? NetworkImage(postedByUser.photo_url) : AssetImage('lib/StockImages/Tree_User_Icon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          postedByUser != null ? postedByUser.display_name : "Invalid User",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(widget.comment['message']),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite_border,
          ),
          color: Colors.grey,
          onPressed: () => print('Like comment'),
        ),
      )
    );
  }
}

class SuppliesCard extends StatefulWidget {
  final event;
  final CollectionReference supplies;

  const SuppliesCard({
    Key key,
    this.event,
    this.supplies
  }) : super(key: key);

  @override
  _SuppliesCardState createState() => _SuppliesCardState();
}

class _SuppliesCardState extends State<SuppliesCard> {

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

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: StreamBuilder<QuerySnapshot> (
                stream: widget.supplies.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print("Supplies - FutureBuilder is called with snapshot: ${snapshot.connectionState}");
                  if (snapshot.hasData) {
                    print("Supplies - Number of items in Snapshot.data.documents: ${snapshot.data.documents.length}");
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return Text(snapshot.data.documents[index]['items']);
                        }
                    );
                  } else if(snapshot.hasError) {
                    return Row(
                      children: <Widget>[
                        Icon(Icons.warning),
                        Text("Whoops... Something went wrong...")
                      ],
                    );
                  } else {
                    return Row(
                      children: <Widget>[
                        SpinKitPouringHourglass(
                          color: Colors.grey,
                        ),
                        Text("Give me a sec...")
                      ],
                    );
                  }
                }
              )
                
            )
          )
        )
      ],
    );
  }
}
