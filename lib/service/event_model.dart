class EventModel {
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

  //blankConstructor cause we don't want the sauce

  Map<String, dynamic> toJson() => {
    "event_id": this.event_id, 
    "team_size": this.team_size.toString(), 
    "lead_user": this.user_id, 
    "event_date": this.event_date, 
    "event_name": this.event_name, 
    "location": this.location, 
    "posted_date": this. posted_date, 
    "likes": this.likes.toString(), 
    "dislikes": this.dislikes.toString(), 
    "comments_amt": this.comments_amt.toString(), 
    "photo": this.photo
  };
}
