class CommentModel {
  var documentID;
  var event_id;
  var posted_by;
  var posted_date;
  var message;
 

  CommentModel({
    this.documentID,
    this.event_id, 
    this.posted_by,
    this.posted_date,
    this.message 
  });

  factory CommentModel.fromJson(var documentID, Map<String, dynamic> json) {
    return CommentModel(
      documentID: documentID,
      event_id: json["event_id"],
      posted_by: json["posted_by"],
      posted_date: json["posted_date"],
      message: json["message"]
    );
  }

  Map<String, dynamic> toJson() => {
    "event_id": this.event_id, 
    "posted_by": this.posted_by,
    "posted_date": this.posted_date,
    "message": this.message 
  };
}
