import 'package:ecoville/EventDetail.dart';
import 'package:ecoville/service/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'service/event.dart';
import 'dart:async';

import 'service/supplies.dart';

class FeedWidget extends StatefulWidget {
  //Information for the feeds
  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  Future<List<Event>> feeds;

  @override
  void initState() {
    super.initState();
    print("InitState() called");
    this.feeds = this.listEvents(); 
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: this.feeds,
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        print("FutureBuilder is called with snapshot: $snapshot");

        if (snapshot.hasData) {
          print("Number of items in Snapshot.data: ${snapshot.data.length}");
          var bigBox = ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
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
                                buildListTile(snapshot.data[index]), //List Tile: User, Date,
                                buildPostImage(snapshot.data[index]), //Actual Image of the Post
                                buildLikesView(snapshot.data[index]) 
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
          );

          return bigBox;

        } else if(snapshot.hasError) {
          var notWorking = Padding(
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

          return notWorking;

        } else {
          var loading = Padding(
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

          return loading;
        }
      }
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

  InkWell buildPostImage(Event event) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => EventDetail(event: event))
        )
      },
      //onDoubleTap() => likeTing
      child: Container(
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

    Future<List<Event>> listEvents() {
      var obj = EventService();
      return obj.list();
    } 
    
}

//End of BigBoy Class
