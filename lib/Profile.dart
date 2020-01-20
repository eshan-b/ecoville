import 'package:flutter/material.dart';
import 'MyEvents.dart';

class ProfilePage extends StatefulWidget {
  final currentUser;
  ProfilePage({@required this.currentUser});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[600],
            Colors.green[300]
          ]
        )
      ),

      child: Column(
        children: <Widget>[
          Image.asset("lib/StockImages/Leaf-top.png"),

          SizedBox(height: 20),

          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                )
              ],
            ),

            child: CircleAvatar(
              child: ClipOval(
                child: Image(
                  height: 100.0,
                  width: 100.0,
                  image: widget.currentUser.photo_url != null ? NetworkImage(widget.currentUser.photo_url) : AssetImage('lib/StockImages/Tree_User_Icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          Text(
            widget.currentUser.display_name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text("My Events"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyEvents(currentUser: widget.currentUser))
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: OutlineButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 20),
                        Text("Log Out"),
                      ],
                    ),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}
