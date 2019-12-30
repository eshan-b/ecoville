import 'package:ecoville/Feed.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Upload.dart';
import 'service/user.dart';
import 'util/color_utils.dart' show HexColor;
//import 'package:ecoville/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  final currentUser;
  HomeScreen({Key key, @required this.currentUser}) : super (key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: FeedWidget(widget.currentUser),
      drawer: drawerTing,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomTing,
      backgroundColor: Colors.grey[400]
    );
  }

  Widget get appBar => AppBar(
    //leading: Image.asset("lib/StockImages/Ecoville_WhiteCropped.png"),
    title: Image.asset(
      'lib/StockImages/Ecoville_WhiteCropped.png',
      scale: 5,
    ),
    backgroundColor: HexColor("#4C9A2A"),
  );

  Widget get drawerTing => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
              Color.fromRGBO(73, 90, 22, 1),
              Color.fromRGBO(73, 130, 22, 0.9)
            ])
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(widget.currentUser['photoUrl']),
          ),
          accountName: Text(widget.currentUser['displayName']), //replace with logged in user
          accountEmail: Text(widget.currentUser['email']),
        ),
        ListTile(title: Text('Eshi 1')),
        ListTile(title: Text('Eshi 2')),

        Container(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings')),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help and Feedback'))
                ],
              )
            )
          )
        )
      ],
    ),
  );

  Widget get floatingActionButton => FloatingActionButton(
    elevation: 2,
    child: Icon(
      Icons.add,
      color: Colors.white,
    ),
    onPressed: () => {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => UploadImage())
      )
    },
  );

  Widget get bottomTing => BottomAppBar(
    shape: CircularNotchedRectangle(),
    notchMargin: 4.0,
    clipBehavior: Clip.antiAlias,
    child: BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          title: Text('Feed'),
          icon: Icon(Icons.home, color: HexColor("#358856")),
        ),

        BottomNavigationBarItem(
          title: Text('Add New Post'),
          icon: Icon(Icons.add),
        ),

        BottomNavigationBarItem(
          title: Text('Profile'),
          icon: Icon(Icons.person)
        )
      ],
    )
  );
}
