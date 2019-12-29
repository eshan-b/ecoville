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
        color: Colors.white,

        child: Column(
          children: <Widget>[
            Image.asset("lib/StockImages/Leaf-top.png"),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Simplicity is Key...\nJoin us to make the world a cleaner place",
                    style: TextStyle(
                      color: Colors.black.withOpacity(.7), 
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

                  SizedBox(height: 20),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage("lib/StockImages/Ecoville_WhiteCropped.png"),
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
                  ),
                ],
              )
            ),

            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Image.asset("lib/StockImages/Leaf-bottom.png")
            ),
          ],
        ),
      )
    );
  }

  OutlineButton buildOutlineButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async => await login(),
      
      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 2,
      borderSide: BorderSide(color: Colors.grey),
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
                  color: Colors.grey 
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
