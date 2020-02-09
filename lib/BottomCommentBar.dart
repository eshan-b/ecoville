import 'package:flutter/material.dart';

import 'service/comment_crud.dart';
import 'service/comment_model.dart';
import 'service/event_model.dart';
import 'service/user_model.dart';

class BottomCommentBar extends StatelessWidget {
  UserModel currentUser;
  EventModel event;
  var commentController = TextEditingController();

  BottomCommentBar({
    Key key,
    this.currentUser,
    this.event
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
              border: InputBorder.none,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.grey),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.grey),
              ),

              contentPadding: EdgeInsets.all(20.0),

              hintText: 'Add a comment',
              prefixIcon: Container(
                margin: EdgeInsets.all(4.0),
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),

                child: CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      height: 48.0,
                      width: 48.0,
                      image: currentUser.photo_url != null ? NetworkImage(currentUser.photo_url) : AssetImage('lib/StockImages/Tree_User_Icon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              suffixIcon: Container(
                margin: EdgeInsets.only(right: 4.0),
                width: 70.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Color(0xFF23B66F),
                  onPressed: () async {
                    var message = commentController.text;
                    CommentModel obj = CommentModel(
                      event_id: event.documentID,
                      message: message,
                      posted_by: currentUser.documentID,
                      posted_date: DateTime.now()
                    );
                    print(obj.toJson());
                    await CommentService(event.documentID).create(obj);
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(
                    Icons.send,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
