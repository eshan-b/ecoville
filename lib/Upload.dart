import 'package:ecoville/HomeScreen.dart';
import 'package:ecoville/service/event_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'Upload2.dart';

class UploadImage extends StatefulWidget {
  final currentUser;
  final EventModel event;
  UploadImage({@required this.currentUser, this.event});

  @override
  _UploadImageState createState() => _UploadImageState(eventModelObject: event);
}

class _UploadImageState extends State<UploadImage> {
  /******* Event Object *******/ //Used throughout 4 screens
  EventModel eventModelObject;

  _UploadImageState({this.eventModelObject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(53, 136, 86, 1),
          ), 
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        centerTitle: true,
        title: Text(
          "Upload Image",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 30,
                width: 12,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(53, 136, 86, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(width: 10),

              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(width: 10),

              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(width: 10),

              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
      body: UploadImageFile(eventModelObject, widget.currentUser)
    );
  }
}

//UploadImageFile
class UploadImageFile extends StatefulWidget {
  var _eventModelObject;
  final currentUser;

  UploadImageFile(this._eventModelObject, this.currentUser);
  
  @override
  _UploadImageFileState createState() => _UploadImageFileState();
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
    var timestamp = DateTime.now().millisecondsSinceEpoch;

    var pathname = basename(_image.path);
    print("pathname: $pathname");
    var extensionIndex = pathname.lastIndexOf(".");
    var fileExt = pathname.substring(extensionIndex);
    print("extension: $fileExt");

    String fileName = "$timestamp$fileExt";
    print("fileName: $fileName");

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
        SizedBox(height: 20),
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

        _image == null && widget._eventModelObject.photo == null ? Container() :
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
              image: _image != null ? Image.file(_image).image : Image.network(widget._eventModelObject.photo).image,
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(height: 20),

        if (_image == null && widget._eventModelObject.photo == null) Container() else
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              borderSide: BorderSide(width: 2, color: Color.fromRGBO(53, 136, 86, 1)),
              color: Color.fromRGBO(53, 136, 86, 1),
              splashColor: Color.fromRGBO(53, 136, 86, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                children: <Widget>[
                  Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.navigate_next, 
                    color: Color.fromRGBO(53, 136, 86, 1),
                    size: 24,
                  ),
                ],
              ),
              onPressed: () {
                return Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: AboutProject(widget._eventModelObject, widget.currentUser)
                  )
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
