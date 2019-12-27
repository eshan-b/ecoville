import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class Comments {
  var event_id;
  var comments_id;
  var posted_by;
  var date;
  var message;

  Comments( //constructor ting
    {
      this.event_id, 
      this.comments_id,
      this.posted_by,
      this.date,
      this.message 
    }
  );

  Map<String, dynamic> toJson() => {
    "event_id": this.event_id, 
    "comments_id": this.comments_id, 
    "posted_by": this.posted_by,
    "date": this.date,
    "message": this.message 
  };

  factory Comments.fromJson(Map<String, dynamic> map) {
    return Comments(
      event_id: map["event_id"],
      comments_id: map["comments_id"], 
      posted_by: map["posted_by"],
      date: map["date"],
      message: map["message"]
    );
  }

  String toString() {
    return json.encode(this);
  }
}

class CommentsService {
  final baseUrl = "http://localhost:3000";

  Future<List<Comments>> list() async {
    var response = await http.get(baseUrl + "/comments");
    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      return body.map((item) => Comments.fromJson(item)).toList();
    } else {
      print("list(): ${response.statusCode}");
    }
  }

  Future<bool> post(Comments comments) async {
    var response = await http.post(baseUrl + "/comments", body: json.encode(comments));
    if (response.statusCode == 201) {
      return true;
    } else {
      print("post(): ${response.statusCode}");
      return false;
    }
  }

  Future<bool> put(Comments comments) async {
    var response = await http.put(baseUrl + "/comments", body: json.encode(comments));
    if (response.statusCode == 204) {
      return true;
    } else {
      print("put(): ${response.statusCode}");
      return false;
    }
  }

  Future<List<Comments>> find_all_comments(var eventId) async {
    var response = await http.get(baseUrl + "/comments/" + eventId);
    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      return body.map((item) => Comments.fromJson(item)).toList();
    } else {
      print("find_all_comments(): ${response.statusCode}");
      return null;
    }
  }

  Future <Comments> find(var eventId, var commentsId) async {
    var response = await http.get(baseUrl + "/comments/" + eventId + "/" + commentsId);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return Comments.fromJson(body);
    } else {
      print("find(): ${response.statusCode}");
      return null;
    }
  }

  Future<bool> delete(var eventId, var commentsId) async {
    var response = await http.delete(baseUrl + "/comments/" + eventId + "/" + commentsId);
    if (response.statusCode == 204) {
      return true;
    } else {
      print("delete(): ${response.statusCode}");
      return false;
    }
  }
}

void main() async { //for Testing
  var service = CommentsService();
  
  var comments = await service.list();
  print("List: $comments");

  var findcomments = await service.find("1", "1");
  print("Found specific supply: $findcomments");

  var findallcomments = await service.find_all_comments("1");
  print("Found all comments for Event 1: $findallcomments");

  findcomments.message = "Bad Project";
  var status = await service.put(findcomments);
  print("Update Status: $status");

  var deleteStatus = await service.delete(findcomments.event_id, findcomments.comments_id);
  print("Delete Status: $deleteStatus");

  var createStatus = await service.post(findcomments);
  print("Create Status: $createStatus");
}
