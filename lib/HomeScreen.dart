import 'package:ecoville/Feed.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Upload.dart';
import 'service/user.dart';
import 'util/color_utils.dart' show HexColor;
//import 'package:ecoville/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  Users currentUser;
  HomeScreen({Key key, @required this.currentUser}) : super (key: key);

  @override

  State<StatefulWidget> createState() {
    

    print(this.currentUser);
    return HomeScreenState(currentUser: this.currentUser);
  }
}


class HomeScreenState extends State<HomeScreen> {
  Users currentUser;
  HomeScreenState({@required this.currentUser});

  int currentIndex = 0; //for BottomNavyBar

  @override

  //Center Text
  Widget build(BuildContext context) {
    var appBar = AppBar(
      //leading: Image.asset("lib/StockImages/Ecoville_WhiteCropped.png"),
      title: Image.asset(
        'lib/StockImages/Ecoville_WhiteCropped.png',
        scale: 5,
      ),
      backgroundColor: HexColor("#4C9A2A"),
    );

    var mapp = NestedScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: false,
              snap: false,

              backgroundColor: Color.fromRGBO(73, 90, 22, 1),

              flexibleSpace:
                FlexibleSpaceBar(
                background: Image.asset(
                  "lib/StockImages/EcoVille_Big_Logo_Shifted.png",
                  fit: BoxFit.cover
                ),
              ),
          )
        ];
      },

      body: FeedWidget(currentUser)
    );

    //Hamburger YumYum Menu
    var drawerTing = Drawer(
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
              backgroundImage: NetworkImage(currentUser.photo),
            ),
            accountName: Text(currentUser.name), //replace with logged in user
            accountEmail: Text(currentUser.email),
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

    var bottomTing = BottomAppBar(
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

    //Top Bar with Text
    var barTing = Scaffold(
      appBar: appBar,
      body: FeedWidget(currentUser),
      drawer: drawerTing,
      floatingActionButton: FloatingActionButton(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomTing,
      backgroundColor: Colors.grey[400]
    );

    return barTing;
  }
}
