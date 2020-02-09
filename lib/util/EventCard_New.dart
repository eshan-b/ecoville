import 'package:intl/intl.dart';
import '../service/event_model.dart';
import '../service/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class EventCardNew extends StatefulWidget {

  final EventModel event;
  final UserModel currentUser;

  const EventCardNew({
    Key key,
    this.currentUser,
    this.event,
  }) : super(key: key);

  @override
  _EventCardNewState createState() => _EventCardNewState();
}

class _EventCardNewState extends State<EventCardNew> {
  UserModel leadUser;
  
  _EventCardNewState({this.leadUser});

  @override
  void initState() {
    super.initState();
    setLeadUser();
  }

  setLeadUser() async {
    UserModel user = await widget.event.user;
    setState(() {
      leadUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Column(
        children: <Widget>[
          buildEventImage(),
          buildEventInfo(),
        ],
      ),
    );
  }

  Widget buildEventImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget.event.photo != null ? NetworkImage(widget.event.photo) : AssetImage("lib/StockImages/Mountain1.jpg"),
          fit: BoxFit.cover
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
    );
  }

  Widget buildEventInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(143, 185, 159, 1),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),

      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.event.event_name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color.fromRGBO(18, 79, 42, 1),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  )
                ),

                SizedBox(width: 20),

                Text(
                  "Event on: ${widget.event.event_date}",
                  style: TextStyle(
                    color: Color.fromRGBO(18, 79, 42, 1),
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          height: 40,
                          width: 40,
                          image: (
                            leadUser != null && leadUser.photo_url != null) ? NetworkImage(leadUser.photo_url) : 
                            AssetImage('lib/StockImages/ChillingFingersIcon.jpg'),
                          fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    leadUser != null ? "${leadUser.display_name}" : "Invalid User",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color.fromRGBO(18, 79, 42, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color.fromRGBO(87, 111, 96, 1),
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
