import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'CommentCardList.dart';
import 'BottomCommentBar.dart';
import 'SuppliesCard.dart';
import 'service/comment_crud.dart';
import 'service/event_model.dart';
import 'service/user_crud.dart';
import 'service/user_model.dart';
import 'service/comment_model.dart';


class EventDetail extends StatefulWidget {
  final UserModel currentUser;
  final EventModel event;

  EventDetail({this.currentUser, this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> with SingleTickerProviderStateMixin {
  Stream<List<CommentModel>> comments;
  UserModel leadUser;
  
  @override
  void initState() {
    super.initState();
    this.comments = CommentService(widget.event.documentID).list();
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
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(widget.event.event_name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => {
            Navigator.pop(context)
          },
        ),
      ),

      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),

          buildImage(),

          SizedBox(height: 20),

          buildTabs(),

          SizedBox(height: 20),

          showIndexTab()
        ],
      ),
      bottomNavigationBar: BottomCommentBar(currentUser: widget.currentUser, event: widget.event)
    );
  }

  Widget buildImage() {
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
          image: widget.event.photo != null ? NetworkImage(widget.event.photo) : AssetImage("lib/StockImages/Mountain1.jpg"), // TBD: change it to uploaded image
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  int selectedIndex = 0;
  final List<String> categories = ['About', "Comments", 'Supplies', 'Location'];

  Widget buildTabs() {
    return Container(
      height: 60,
      color: Colors.green[300],
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60/3,vertical: 60/4),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: index == selectedIndex ? Colors.white : Colors.white60,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                )
              )
            )
          );
        }
      )
    );
  }

  Widget showIndexTab() {
    if (selectedIndex == 0) 
      return buildAbout();
    else if (selectedIndex == 1) 
      return CommentCardList(event: widget.event, currentUser: widget.currentUser);
    else if (selectedIndex == 2) 
      return SuppliesCard(event: widget.event);
    else 
      return Text("Tab 4");
  }

  Widget buildAbout() {
    return Column(
      children: <Widget>[
        buildUserCard(),
        Text("Posted on: ${DateFormat.yMd().add_jm().format(widget.event.posted_date.toDate())}"),
        Text("Event on: ${widget.event.event_date} | ${widget.event.event_time}")
      ],
    );
  }

  Card buildUserCard() {
    return Card(
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Colors.black45, offset: Offset(0, 2), blurRadius: 6.0
              )
            ]
          ),

          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50,
                width: 50,
                image: (leadUser != null && leadUser.photo_url != null) ? NetworkImage(leadUser.photo_url) : AssetImage('lib/StockImages/TreeUserIcon.png'),
                fit: BoxFit.cover
              ),
            ),
          ),
        ),

        title:Text(leadUser.display_name)
      )
    );
  }

}
