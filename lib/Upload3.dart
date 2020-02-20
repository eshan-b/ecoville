import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'Upload4.dart';
import 'dart:io';

class AddRemoveListView extends StatefulWidget {
  var _eventModelObject;
  final currentUser;
  AddRemoveListView(this._eventModelObject, this.currentUser);

  @override
  _AddRemoveListViewState createState() => _AddRemoveListViewState();
}

class _AddRemoveListViewState extends State<AddRemoveListView> {
  TextEditingController _textController = TextEditingController();

  List<String> _listViewData = [];

  _onSubmit() {
    setState(() {
      print("add called");
      _listViewData.add(_textController.text);
      _textController.text = "";
    });
  }

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
          "Supplies",
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
                height: 12,
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
                  color: Color.fromRGBO(53, 136, 86, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(width: 10),
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
            ],
          ),
        ),
      ),

      body: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _textController,

                    decoration: InputDecoration(
                      labelText: "What supplies do you need?",
                    ),
                  ),

                  FlatButton(
                    onPressed: _onSubmit,
                    splashColor: Colors.grey[400], 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add),
                        Text("Add the supply")
                      ],
                    )
                  ),
                ],
              ),
            ),

          SizedBox(height: 20.0),

          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _listViewData.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final data = _listViewData[index];
              
                return Dismissible(
                  key: Key(data),
                  onDismissed: (direction) {
                    setState(() {
                      _listViewData.remove(data);
                    });

                    Scaffold.of(context)
                      .showSnackBar(
                        SnackBar(
                          content: Text("$data deleted"),
                        )
                      );
                  },
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.white
                        ),
                        Text(
                          "  Delete",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                      ],
                    )
                  ),
                  child: ListTile(
                    title: Text(data),
                  ),
                );
              },
            ),
          ),
          
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
                  widget._eventModelObject.supplies = _listViewData;
                  if (_listViewData.length == 0) {
                    return showDialog<void> (
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext build) {
                        return AlertDialog(
                          title: Text("Confirmation to proceed"),
                          content: Text("Are you sure that you want to continue without any supplies"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("CLOSE"),
                              onPressed: () => {
                                Navigator.of(context).pop()
                              },
                            ),
                            FlatButton(
                              child: Text("CONTINUE"),
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: EnterLocation(widget._eventModelObject, widget.currentUser)
                                  ),
                                ),
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: EnterLocation(widget._eventModelObject, widget.currentUser)
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}
