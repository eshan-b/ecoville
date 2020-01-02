class UserModel {
  var documentID;
  var display_name;
  var photo_url;
  var user_id;
  var email;
 

  UserModel({
    this.documentID,
    this.display_name,
    this.photo_url,
    this.user_id,
    this.email,
  });

  factory UserModel.fromJson(var documentID, Map<String, dynamic> json) {
    return UserModel(
      documentID: documentID,
      display_name: json['display_name'],
      photo_url: json['photo_url'],
      user_id: json['user_id'],
      email: json['email']
    );
  }

  Map<String, dynamic> toJson() => {
    "display_name": this.display_name,
    "photo_url": this.photo_url,
    "user_id": this.user_id,
    "email": this.email
  };
}
