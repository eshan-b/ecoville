import 'package:flutter/material.dart';
import 'dart:io';
import 'HomeScreen.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'service/user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    "email",
  ]
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
        isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Simplicity is Key...\nJoin us to make the world a cleaner place",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.7), 
                      height: 1.4, 
                      fontSize: 20
                    ),
                  ),

                  SizedBox(height: 30),

                  (isLoading == true) ?
                    Center(
                      child: SpinKitThreeBounce(
                        color: Colors.green,
                        size: 35,
                      )
                    )
                  :
                    buildOutlineButton()
                  ,
                  
                  //isLoading ? Center(child: CircularProgressIndicator()) : Container(),

                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("lib/StockImages/Ecoville_WhiteCropped.png"),
                        color: Colors.white,
                        height: 50
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Made by Chilling Fingers",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ],
              )
            ),

            Expanded(
                child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Image.asset("lib/StockImages/Leaf-bottom.png")
              ),
            ),
          ],
        ),
      )
    );
  }

  RaisedButton buildOutlineButton() {
    return RaisedButton(
      splashColor: Colors.green[600],
      onPressed: () async => await login(),
      
      color: Colors.green[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Image(image: AssetImage("lib/StockImages/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white 
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    GoogleSignInAccount _currentUser = await _googleSignIn.signIn();

    if (_currentUser != null) {
      setState(() {
        isLoading = true;
      });

      print("Logged-in successfully");
      var service = UsersService();
      var dbUser = await service.find(_currentUser.id);
      
      if (dbUser == null) {
        print("User not found in database");
        dbUser = Users();
        dbUser.name = _currentUser.displayName;
        dbUser.email = _currentUser.email;
        dbUser.user_id = _currentUser.id;
        dbUser.photo = _currentUser.photoUrl;

        print("Creating user in database");
        var createStatus = await service.post(dbUser);
        print("CreateStatus: $createStatus");
      }

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(currentUser: dbUser)
        )
      );
    }
  }

}
