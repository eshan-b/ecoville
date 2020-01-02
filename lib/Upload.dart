import 'package:ecoville/HomeScreen.dart';
import 'package:ecoville/service/event_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'Upload2.dart';

class UploadImage extends StatefulWidget {
  final currentUser;
  UploadImage({@required this.currentUser});

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  /******* Event Object *******/ //Used throughout 4 screens
  var eventModelObject = EventModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            Text("Upload Image"),

            RaisedButton(
              onPressed: () => {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => HomeScreen(currentUser: widget.currentUser)) //Just to pass currentUser back to Home Page
                )
              },
              splashColor: Colors.green[600],
              color: Colors.green[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              highlightElevation: 1,

              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white 
                  ),
                ),
              ),
            ),
          ]
        ),
      ),

      body: UploadImageFile(eventModelObject, widget.currentUser)
    );
  }
}

//UploadImageFile
class UploadImageFile extends StatefulWidget {
  @override
  _UploadImageFileState createState() => _UploadImageFileState();

  var _eventModelObject;
  final currentUser;

  /*** Constructor GANG ***/ //for passing my object down here
  UploadImageFile(this._eventModelObject, this.currentUser);
}

class _UploadImageFileState extends State<UploadImageFile> {
  File _image;

  Future getImage(bool isCamera) async {
    File image;

      if(isCamera) {
        image = await ImagePicker.pickImage(source: ImageSource.camera);      
      } else {
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
      }

    setState(() {
      _image = image;
    });

    
  }

  Future uploadPic(BuildContext context) async{
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    widget._eventModelObject.photo = await taskSnapshot.ref.getDownloadURL();
    print(widget._eventModelObject.photo);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton( //gallery button
                onPressed: () => {
                  getImage(false)
                },
                color: Colors.green[200],
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.file_upload),
                    Text("  Add from gallery")
                  ]
                )
              ),

              SizedBox(width: 10),

              RaisedButton( //camera button
                onPressed: () => {
                  getImage(true)
                },
                color: Colors.green[200],
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    Text("  Take a picture")
                  ]
                )
              ),

            ],
          ),
        ),

        SizedBox(height: 20),

        _image == null ? Container() :
        Container(
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
              image: Image.file(_image).image,
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(height: 20),

        _image == null ? Container() :
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                uploadPic(context);

                return Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutProject(widget._eventModelObject, widget.currentUser))
                );
              },
              color: Colors.green[200],
              splashColor: Colors.green[600],
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              highlightElevation: 1,
              child: Row(
                children: <Widget>[
                  Text("Next"),
                  Icon(Icons.arrow_forward)
                ]
              )
            ),
          ],
        ),
        
      ],
    );
  }
}
