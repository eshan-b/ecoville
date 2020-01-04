import 'package:flutter/material.dart';

import 'service/comment_model.dart';
import 'service/user_crud.dart';
import 'service/user_model.dart';

class CommentCard extends StatefulWidget {
  final CommentModel comment;
  
  const CommentCard({
    Key key,
    @required this.comment
  }) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  UserModel postedByUser;

  @override
  void initState() {
    super.initState();
    findPostedBy();
  }

  Future findPostedBy() async {
    UserModel user = await UserService().find(widget.comment.posted_by);
    if(mounted) {  
      setState(() {
        this.postedByUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
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
                height: 50.0,
                width: 50.0,
                image: (postedByUser != null && postedByUser.photo_url != null) ? NetworkImage(postedByUser.photo_url) : AssetImage('lib/StockImages/Tree_User_Icon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          postedByUser != null ? postedByUser.display_name : "Invalid User",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(widget.comment.message)
      )
    );
  }
}
