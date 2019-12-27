import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'Upload2.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
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


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload Image"),
        ),

        body: Column(
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
            Expanded(
              child: RaisedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => aboutProject())
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
        )
      ),
    );
  }
}
