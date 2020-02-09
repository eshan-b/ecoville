import 'package:flutter/material.dart';

import 'service/event_model.dart';

class SuppliesCard extends StatefulWidget {
  final EventModel event;

  const SuppliesCard({
    Key key,
    this.event,
  }) : super(key: key);

  @override
  _SuppliesCardState createState() => _SuppliesCardState();
}

class _SuppliesCardState extends State<SuppliesCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.event.supplies.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Container(
            padding: EdgeInsets.all(20), // for content inside
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(
                color: Colors.grey,
                blurRadius: 6.0,
                offset: Offset(0, 2)
              )]
            ),
            child: Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildBulletPoint(),
                    SizedBox(width: 10),
                    Text(
                      widget.event.supplies[index].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget buildBulletPoint() {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(53, 136, 86, 1),
      ),
    );
  }
}
