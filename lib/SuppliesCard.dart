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
                  return Text(widget.event.supplies[index].toString());
                }
              );
  }
}
