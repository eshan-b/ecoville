import 'package:flutter/material.dart';

import 'MyEvents.dart';
import 'Upload.dart';
import 'LoginScreen.dart';
import 'Feed.dart';
import 'service/user_model.dart';
import 'service/event_model.dart';

class HomeScreen extends StatefulWidget {
  final UserModel currentUser;
  HomeScreen({@required this.currentUser});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dropdownValue = 'Most Recent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: <Widget>[
          buildHeaderRow(context),
          SizedBox(height: 10),
          Expanded(child: FeedWidget(widget.currentUser))
        ],
      ),
      drawer: buildDrawer(),
      backgroundColor: Colors.white,
    );
  }

  Widget buildHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15.0),
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(53, 136, 86, 1),
            ),
            underline: Container(
              height: 2,
              color: Color.fromRGBO(53, 136, 86, 1),
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Most Recent']
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
          child: Row(
            children: <Widget>[
              Text(
                "Add Post",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.zero,
                shape: CircleBorder(),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                color: Color.fromRGBO(53, 136, 86, 1),
                onPressed: () => {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => UploadImage(currentUser: widget.currentUser, event: EventModel()))
                  )
                }
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: Image.asset(
          'lib/StockImages/Ecoville_WhiteCropped.png',
          scale: 5,
        ),
        backgroundColor: Color.fromRGBO(53, 136, 86, 1)
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      elevation: 1.5, //for shadow
      child: Column(
        children: <Widget> [
          Container(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(53, 136, 86, 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.currentUser.photo_url),
                        fit: BoxFit.fill,
                      )
                    ),
                  ),

                  SizedBox(width: 20),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.currentUser.display_name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ), 

                      SizedBox(height: 10),

                      Text(
                        widget.currentUser.email,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(20),
                  leading: Icon(
                    Icons.event,
                    size: 32,
                  ),
                  title: Text(
                    'My Events',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyEvents(currentUser: widget.currentUser))
                    );
                  },
                ),
              ],
            ),
          ),

          Divider(),

          Container(
            height: 75,
            padding: EdgeInsets.all(15),
            child: OutlineButton(
              borderSide: BorderSide(width: 2, color: Color.fromRGBO(53, 136, 86, 1)),
              color: Color.fromRGBO(53, 136, 86, 1),
              splashColor: Color.fromRGBO(53, 136, 86, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app, 
                    color: Color.fromRGBO(53, 136, 86, 1),
                    size: 32,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                return Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
