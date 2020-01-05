class EventSignupModel {
  var documentID;
  var signed_user;
  var event_id;
 
  EventSignupModel({
    this.documentID,
    this.signed_user,
    this.event_id
  });

  factory EventSignupModel.fromJson(var documentID, Map<String, dynamic> json) {
    return EventSignupModel(
      documentID: documentID,
      signed_user: json["signed_user"],
      event_id: json["event_id"]
    );
  }

  Map<String, dynamic> toJson() => {
    "signed_user": this.signed_user,
    "event_id": this.event_id
  };
}
