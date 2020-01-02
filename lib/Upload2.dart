import 'package:ecoville/Upload3.dart';
import 'package:ecoville/service/event_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class AboutProject extends StatefulWidget {
  var _eventModelObject;
  final currentUser;
  AboutProject(this._eventModelObject, this.currentUser);

  @override
  _AboutProjectState createState() => _AboutProjectState();
}

class _AboutProjectState extends State<AboutProject> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  
  final timeFormatter = DateFormat.jm();
  var formatter = DateFormat("MM/dd/yyyy"); //date Formatter
  String time12Hour;

  _AboutProjectState() {
    time12Hour = timeFormatter.format(DateTime.now());
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showRoundedDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year+2),
      borderRadius: 16,
      theme: ThemeData(primarySwatch: Colors.green)
    );

    if (picked != null && picked != _date) {
      print("Date Selected:  ${_date.toString()}");
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showRoundedTimePicker(
      context: context,
      initialTime: _time,
      borderRadius: 16,
      theme: ThemeData(primarySwatch: Colors.green)
    );

    final now = DateTime.now();
    final dt = picked != null ? DateTime(now.year, now.month, now.day, picked.hour, picked.minute) : now; //avoid getting null
    
    time12Hour = timeFormatter.format(dt);

    if (picked != null && picked != _time) {
      print("Time Selected:  ${_time.toString()}");
      setState(() {
        _time = picked;
      });
    }
  }

  final eventNameController = TextEditingController();
  final teamSizeController = TextEditingController();
  /*Pretend there are two more controllers here*/
  /*The other controllers are actually variables*/ 
  //TBD if want remember what user chose for date and time

  @override
  void initState() {
    super.initState();
    if (widget._eventModelObject != null) {
      eventNameController.text = widget._eventModelObject.event_name;
      teamSizeController.text = widget._eventModelObject.team_size;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Event Description"),
        ),

        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: TextFormField(
                controller: eventNameController,

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },

                decoration: InputDecoration(
                  labelText: 'What is your project name?'
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => {
                      _selectDate(context)
                    },
                    color: Colors.green[200],
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.date_range),
                        Text("  Choose Date")
                      ]
                    )
                  ),

                  Text("   Date Selected:  ${formatter.format( _date)}")
                ],
              )
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => {
                      _selectTime(context)
                    },
                    color: Colors.green[200],
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.access_time),
                        Text("  Choose Time")
                      ]
                    )
                  ),

                  Text("   Time Selected:  $time12Hour")
                ],
              )
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: TextFormField(
                controller: teamSizeController,

                decoration: InputDecoration(
                  labelText: 'How many people are attending?'
                ),

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),

            SizedBox(height: 20),

            RaisedButton(
              onPressed: () {
                widget._eventModelObject.event_name = eventNameController.text;
                widget._eventModelObject.team_size = teamSizeController.text;
                widget._eventModelObject.event_date = formatter.format(_date);
                widget._eventModelObject.event_time = time12Hour;

                return Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => AddRemoveListView(widget._eventModelObject, widget.currentUser))
                );
              },

              color: Colors.green[200],
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.arrow_forward),
                  Text("  Next")
                ]
              )
            ),

          ],
        ),
      )
    );
  }
}
