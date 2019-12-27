import 'package:ecoville/Upload3.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class aboutProject extends StatefulWidget {
  @override
  _aboutProjectState createState() => _aboutProjectState();
}

class _aboutProjectState extends State<aboutProject> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  
  final timeFormatter = DateFormat.jm();
  var formatter = DateFormat("MM/dd/yyyy"); //date Formatter
  var time12Hour;

  _aboutProjectState() {
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
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Project Info"),
        ),

        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: TextFormField(
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

                  Text("   Time Selected:  ${time12Hour}")
                ],
              )
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'How many people are attending?'
                ),
              ),
            ),

            SizedBox(height: 20),

            RaisedButton(
              onPressed: () => {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => AddRemoveListView())
                )
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
