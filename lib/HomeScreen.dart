import 'package:ecoville/Feed.dart';
import 'package:ecoville/service/event_model.dart';
import 'package:flutter/material.dart';
import 'Upload.dart';
import 'Profile.dart';
import 'service/user_model.dart';
import 'util/color_utils.dart' show HexColor;

class HomeScreen extends StatefulWidget {
  final UserModel currentUser;
  HomeScreen({@required this.currentUser});

  @override
  State<StatefulWidget> createState() => _HomeScreenState(this.currentUser);
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  List<Widget> _pageOptions = []; //set blank

  _HomeScreenState(UserModel currentUser) {
    _pageOptions.add(FeedWidget(currentUser));
    _pageOptions.add(ProfilePage(currentUser: currentUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: _pageOptions[_selectedTab],
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
    backgroundColor: HexColor("#4C9A2A")
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
        MaterialPageRoute(builder: (context) => UploadImage(currentUser: widget.currentUser, event: EventModel()))
      )
    },
  );

  Widget get bottomTing => BottomAppBar(
    shape: CircularNotchedRectangle(),
    notchMargin: 4.0,
    clipBehavior: Clip.antiAlias,
    child: BottomNavigationBar(
      currentIndex: _selectedTab,     
      onTap: (int index) {
        setState(() {
          _selectedTab = index;
        });
      },
      items: <BottomNavigationBarItem> [
        BottomNavigationBarItem(
          title: Text('Feed'),
          icon: Icon(Icons.home, color: HexColor("#358856")),
        ),

        BottomNavigationBarItem(
          title: Text('Profile'),
          icon: Icon(Icons.person)
        )
      ],
    )
  );
}
