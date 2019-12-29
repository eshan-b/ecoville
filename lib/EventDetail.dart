import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

import 'service/comments.dart';
import 'service/event.dart';
import 'service/supplies.dart';
import 'service/user.dart';

import 'util/EventCard.dart';

import 'package:expand_widget/expand_widget.dart'; //for expand text (readMore)

import 'util/read_more_text.dart';

class EventDetail extends StatefulWidget {
  Users currentUser;
  Event event;

  EventDetail({this.currentUser, this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: ListView(
        children: <Widget>[
          buildHeader(context),

          SizedBox(height: 10),

          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0)),
            ),
            child: ListView(
              primary: false,
              //physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                EventCard(currentUser: widget.currentUser, event: widget.event),

                SizedBox(height: 20),

                SuppliesCard(event: widget.event),

                SizedBox(height: 20),

                CommentsCard(event: widget.event),
              ],
            )
          )
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

}

class BottomCommentBar extends StatelessWidget {
  final Users currentUser;

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
                      image: currentUser.photo != null ? NetworkImage(currentUser.photo) : Icons.person,
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
  final Event event;

  const CommentsCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  @override
  _CommentsCardState createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  Future<List<Comments>> comments;

  @override
  void initState() {
    super.initState();
    this.comments = CommentsService().find_all_comments(widget.event.event_id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
              borderRadius: BorderRadius.circular(25.0),
            ),

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: FutureBuilder<List<Comments>> (
                future: comments,
                builder: (BuildContext context, AsyncSnapshot<List<Comments>> snapshot) {
                  if (snapshot.hasData) {
                    return ExpandChild(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BuildComment(comment: snapshot.data[index]);
                        }
                      ),
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
  final Comments comment;
  
  const BuildComment({
    Key key,
    @required this.comment
  }) : super(key: key);

  @override
  _BuildCommentState createState() => _BuildCommentState();
}

class _BuildCommentState extends State<BuildComment> {
  Future<Users> postedBy;

  @override
  void initState() {
    super.initState();
    this.postedBy = UsersService().find(widget.comment.posted_by);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FutureBuilder<Users> (
        future: postedBy,
        builder: (BuildContext context, AsyncSnapshot<Users> snapshot) {
          if (snapshot.hasData) {
            return ListTile(
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
                        image: snapshot.data.photo != null ? NetworkImage(snapshot.data.photo) : AssetImage('lib/StockImages/Tree_User_Icon.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  snapshot.data.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(widget.comment.message),
                trailing: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  color: Colors.grey,
                  onPressed: () => print('Like comment'),
                ),
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
    );
  }
}

class SuppliesCard extends StatefulWidget {
  final Event event;

  const SuppliesCard({
    Key key,
    this.event
  }) : super(key: key);

  @override
  _SuppliesCardState createState() => _SuppliesCardState();
}

class _SuppliesCardState extends State<SuppliesCard> {
  Future<List<Supplies>> supplies;

  @override
  void initState() {
    super.initState();
    this.supplies = SuppliesService().find_all_supplies(widget.event.event_id);
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

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: <Widget>[
                  Text("Supplies"),

                  FutureBuilder<List<Supplies>> (
                    future: supplies,
                    builder: (BuildContext context, AsyncSnapshot<List<Supplies>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Text(snapshot.data[index].supply_name);
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
                ],
              )
            )
          )
        )
      ],
    );
  }
}
