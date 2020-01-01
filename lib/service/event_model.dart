class EventModel {
  var documentID;
  var event_id;
  int team_size;
  var user_id;
  var lead_user;
  var event_date;
  var event_name;
  var location;
  var posted_date;
  int likes = 0;
  int dislikes = 0;
  int comments_amt = 0;
  var photo;

  EventModel({
    this.documentID,
    this.event_id,
    this.team_size,
    this.user_id,
    this.event_date,
    this.event_name,
    this.location,
    this.posted_date,
    this.likes,
    this.dislikes,
    this.comments_amt,
    this.photo,
  });

  factory EventModel.fromJson(var documentID, Map<String, dynamic> json) {
    return EventModel(
      documentID: documentID,
      event_id: json['event_id'],
      team_size: json['team_size'],
      user_id: json['user_id'],
      event_date: json['event_date'],
      event_name: json['event_name'],
      location: json['location'],
      posted_date: json['posted_date'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      comments_amt: json['comments_amt'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() => {
    "event_id": this.event_id, 
    "team_size": this.team_size.toString(), 
    "lead_user": this.user_id, 
    "event_date": this.event_date, 
    "event_name": this.event_name, 
    "location": this.location, 
    "posted_date": this.posted_date, 
    "likes": this.likes.toString(), 
    "dislikes": this.dislikes.toString(), 
    "comments_amt": this.comments_amt.toString(), 
    "photo": this.photo
  };
}
