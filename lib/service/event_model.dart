class EventModel {
  var documentID;
  var event_id;
  var team_size;
  var lead_user;
  var event_date;
  var event_time;
  var event_name;
  var location;
  var posted_date;
  int likes = 0;
  int dislikes = 0;
  int comments_amt = 0;
  var photo;
  var supplies;

  EventModel({
    this.documentID,
    this.event_id,
    this.team_size,
    this.lead_user,
    this.event_date,
    this.event_time,
    this.event_name,
    this.location,
    this.posted_date,
    this.likes,
    this.dislikes,
    this.comments_amt,
    this.photo,
    this.supplies,
  });

  factory EventModel.fromJson(var documentID, Map<String, dynamic> json) {
    
    return EventModel(
      documentID: documentID,
      event_id: json['event_id'],
      team_size: json['team_size'],
      lead_user: json['lead_user'],
      event_date: json['event_date'],
      event_time: json['event_time'],
      event_name: json['event_name'],
      location: json['location'],
      posted_date: json['posted_date'],
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      comments_amt: json['comments_amt'] ?? 0,
      photo: json['photo'],
      supplies: json['supplies']
    );
  }

  Map<String, dynamic> toJson() => {
    "event_id": this.event_id, 
    "team_size": this.team_size, 
    "lead_user": this.lead_user, 
    "event_date": this.event_date,
    "event_time": this.event_time, 
    "event_name": this.event_name, 
    "location": this.location, 
    "posted_date": this.posted_date, 
    "likes": this.likes ?? 0, 
    "dislikes": this.dislikes ?? 0, 
    "comments_amt": this.comments_amt ?? 0,
    "supplies": this.supplies
  };
}
