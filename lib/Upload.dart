import 'package:ecoville/Upload3.dart';
import 'package:ecoville/Upload4.dart';
import 'package:ecoville/service/event_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'Upload2.dart';


class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> with SingleTickerProviderStateMixin {
  /******* Event Object *******/ //Used throughout 4 screens
  var eventModelObject = EventModel();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(_onTabChange);
  }

  void _onTabChange() {
    print("Tab Index: ${_tabController.index}");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              Text("Upload Image"),
              RaisedButton(
                onPressed: () {
                  //uploadPic(context);
                },
                splashColor: Colors.green[600],
                color: Colors.green[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                highlightElevation: 1,

                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Create',
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

        body: UploadImageFile(eventModelObject)
      ),
    );
  }
}

//UploadImageFile
class UploadImageFile extends StatefulWidget {
  @override
  _UploadImageFileState createState() => _UploadImageFileState();

  var _eventModelObject;

  /*** Constructor GANG ***/ //for passing my object down here
  UploadImageFile(this._eventModelObject);
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

    widget._eventModelObject.photo = _image;
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

        _image == null ? Container() : //
        Expanded(
          child: RaisedButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => aboutProject(widget._eventModelObject))
              )
            },
            color: Colors.green[200],
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_forward),
                Text(" Next")
              ]
            )
          ),
        ),
        
      ],
    );
  }
}
