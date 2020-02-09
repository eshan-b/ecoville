import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Upload.dart';
import 'service/event_crud.dart';
import 'service/event_model.dart';
import 'service/user_crud.dart';
import 'service/user_model.dart';

enum Menu {edit, delete} //for Pop-up Menu

class MyEvents extends StatefulWidget {
  final UserModel currentUser;
  final EventModel event;

  MyEvents({this.currentUser, this.event});

  @override
  _MyEventsState createState() => _MyEventsState(currentUser);
}

class _MyEventsState extends State<MyEvents> {
  Stream<List<EventModel>> events;
  final UserModel currentUser; //created duplicate

  _MyEventsState(this.currentUser);

  @override
  void initState() {
    super.initState();
    this.events = EventService().userList(currentUser.documentID);
  }

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
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title:Text("My Events"),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => {
            Navigator.pop(context)
          },
        ),
      ),

      body: buildEventListCards(),
    ) ;
    
  }

  StreamBuilder<List<EventModel>> buildEventListCards() {
    return StreamBuilder<List<EventModel>> (
      stream: events,
      builder: (BuildContext context, AsyncSnapshot<List<EventModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              EventModel event = snapshot.data[index];
              findLeadUser(event);
              return buildMiniCard(event);
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

  Widget buildMiniCard(EventModel event) {
    return Card(
      child: ListTile(
        title: Text(event.event_name),
        subtitle: Text(event.event_date),
        trailing: buildPopupMenuButton(event)
      )
    );
  }

  Widget buildPopupMenuButton(EventModel event) {
    return PopupMenuButton<Menu>(
      onSelected: (Menu result) {
        pickMenu(result, event);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>> [
        PopupMenuItem<Menu>(
          value: Menu.edit,
          child: Row(
            children: <Widget>[
              Icon(Icons.edit),
              SizedBox(width: 10),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem<Menu>(
          value: Menu.delete,
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              SizedBox(width: 10),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }

  void pickMenu(Menu result, EventModel event) async {
    if(result == Menu.delete) {
      print("Deleting Event");
      await EventService().delete(event.documentID);
      setState(() {
        this.events = EventService().userList(currentUser.documentID);
      });
    } else if(result == Menu.edit) {  
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => UploadImage(currentUser: widget.currentUser, event: event))
      );
    }
  }
}
