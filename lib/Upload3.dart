import 'package:flutter/material.dart';
import 'Upload4.dart';
import 'dart:io';

class AddRemoveListView extends StatefulWidget {
  var _eventModelObject;
  AddRemoveListView(this._eventModelObject);

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
      appBar: AppBar(
        title: Text('Supplies for Event'),
      ),

      body: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _textController,

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },

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

          RaisedButton(
            onPressed: () => {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => enterLocation(widget._eventModelObject))
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
      )
    );
  }
}
