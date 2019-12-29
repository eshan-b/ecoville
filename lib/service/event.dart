import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class Event {
  var event_id;
  var team_size = "0";
  var user_id;
  var lead_user;
  var event_date;
  var name;
  var location;
  var posted_date;
  var likes = "0";
  var dislikes = "0";
  var comments_amt = "0";
  var photo_url;

  Event( //constructor ting
    {
      this.event_id, 
      this.team_size, 
      this.user_id, 
      this.event_date, 
      this.name, 
      this.location, 
      this.posted_date, 
      this.likes, 
      this.dislikes, 
      this.comments_amt, 
      this.photo_url
    }
  );

  Map<String, dynamic> toJson() => {
    "event_id": this.event_id, 
    "team_size": this.team_size.toString(), 
    "lead_user": this.user_id, 
    "event_date": this.event_date, 
    "name": this.name, 
    "location": this.location, 
    "posted_date": this. posted_date, 
    "likes": this.likes.toString(), 
    "dislikes": this.dislikes.toString(), 
    "comments_amt": this.comments_amt.toString(), 
    "photo_url": this.photo_url
  };

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
      event_id: map["event_id"], 
      team_size: map["team_size"].toString(), 
      user_id: map["lead_user"], 
      event_date: map["event_date"], 
      name: map["name"], 
      location: map["location"], 
      posted_date: map["posted_date"], 
      likes: map["likes"].toString(), 
      dislikes: map["dislikes"].toString(), 
      comments_amt: map["comments_amt"].toString(), 
      photo_url: map["photo_url"]
    );
  }

  String toString() {
    return json.encode(this);
  }
}

class EventService {
  final baseUrl = "http://192.168.137.100:3000";

  Future<List<Event>> list() async {
    print("Going to fetch events...");
    var response = await http.get(baseUrl + "/event");
    if (response.statusCode == 200) {
      print("Successfully fetched events");
      var body = json.decode(response.body) as List;
      return body.map((item) => Event.fromJson(item)).toList();
    } else {
      print("list(): ${response.statusCode}");
    }
  }

  Future<bool> post(Event event) async {
    var response = await http.post(baseUrl + "/event", body: json.encode(event));
    if (response.statusCode == 201) {
      return true;
    } else {
      print("post(): ${response.statusCode}");
      return false;
    }
  }

  Future<bool> put(Event event) async {
    var response = await http.put(baseUrl + "/event", body: json.encode(event));
    if (response.statusCode == 204) {
      return true;
    } else {
      print("put(): ${response.statusCode}");
      return false;
    }
  }

  Future<Event> find(var eventId) async {
    var response = await http.get(baseUrl + "/event/" + eventId);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return Event.fromJson(body);
    } else {
      print("find(): ${response.statusCode}");
      return null;
    }
  }

  Future<bool> delete(var eventId) async {
    var response = await http.delete(baseUrl + "/event/" + eventId);
    if (response.statusCode == 204) {
      return true;
    } else {
      print("delete(): ${response.statusCode}");
      return false;
    }
  }
}

void main() async {
  var item = 
  '''{
      "event_id": "1",
      "team_size": "10",
      "lead_user": "User1",
      "event_date": "2/10/2020",
      "name": "300 Subscribers",
      "location": "1041 Nerge Road",
      "posted_date": "11/22/2004"
    }''';
  
  Map<String, dynamic> map = json.decode(item);

  var event = Event.fromJson(map);
  var service = EventService();
  //var events = await service.list();
  var findEvent = await service.find("4");
  print("Found Event 4: $findEvent");
  findEvent.likes = "5";
  var status = await service.put(findEvent);
  print("Update Status: $status");

  var deleteStatus = await service.delete(findEvent.event_id);
  print("Delete Status: $deleteStatus");

  var createStatus = await service.post(findEvent);
  print("Create Status: $createStatus");
}
