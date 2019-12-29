import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class Users {
  var name;
  var photo;
  var user_id;
  var email;

  Users( //constructor ting
    {
      this.name,
      this.photo,
      this.user_id,
      this.email
    }
  );

  Map<String, dynamic> toJson() => {
    "name": this.name,
    "photo": this.photo,
    "user_id": this.user_id,
    "email": this.email
  };

  factory Users.fromJson(Map<String, dynamic> map) {
    return Users(
      name: map["name"],
      photo: map["photo"],
      user_id: map["user_id"],
      email: map["email"]
    );
  }

  String toString() {
    return json.encode(this);
  }
}

class UsersService {
  final baseUrl = "http://192.168.137.100:3000";

  Future<List<Users>> list() async {
    var response = await http.get(baseUrl + "/users");
    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      return body.map((item) => Users.fromJson(item)).toList();
    } else {
      print("list(): ${response.statusCode}");
    }
  }

  Future<bool> post(Users user) async {
    var response = await http.post(baseUrl + "/users", body: json.encode(user));
    if (response.statusCode == 201) {
      return true;
    } else {
      print("post(): ${response.statusCode}");
      return false;
    }
  }

  Future<bool> put(Users user) async {
    var response = await http.put(baseUrl + "/users", body: json.encode(user));
    if (response.statusCode == 204) {
      return true;
    } else {
      print("put(): ${response.statusCode}");
      return false;
    }
  }

  Future<Users> find(var userId) async {
    var response = await http.get(baseUrl + "/users/" + userId);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return Users.fromJson(body);
    } else {
      print("find() $userId: ${response.statusCode}");
      return null;
    }
  }

  Future<bool> delete(var userId) async {
    var response = await http.delete(baseUrl + "/users/" + userId);
    if (response.statusCode == 204) {
      return true;
    } else {
      print("delete(): ${response.statusCode}");
      return false;
    }
  }
}

void main() async {
  var service = UsersService();

  var users = await service.list();
  print("List: $users");

  var findUsers = await service.find("4");
  print("Found Users 4: $findUsers");
  findUsers.email = "chillingfingersbusiness@gmail.com";
  var status = await service.put(findUsers);
  print("Update Status: $status");

  var deleteStatus = await service.delete(findUsers.user_id);
  print("Delete Status: $deleteStatus");

  var createStatus = await service.post(findUsers);
  print("Create Status: $createStatus");
}
