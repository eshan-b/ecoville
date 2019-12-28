import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class Supplies {
  var event_id;
  var supplies_id;
  var supply_name;

  Supplies( //constructor ting
    {
      this.event_id, 
      this.supplies_id,
      this.supply_name   
    }
  );

  Map<String, dynamic> toJson() => {
    "event_id": this.event_id, 
    "supplies_id": this.supplies_id, 
    "supply_name": this.supply_name, 
  };

  factory Supplies.fromJson(Map<String, dynamic> map) {
    return Supplies(
      event_id: map["event_id"],
      supplies_id: map["supplies_id"],
      supply_name: map["supply_name"]
    );
  }

  String toString() {
    return json.encode(this);
  }
}

class SuppliesService {
  final baseUrl = "http://192.168.137.100:3000";

  Future<List<Supplies>> list() async {
    var response = await http.get(baseUrl + "/supplies");
    if (response.statusCode == 200) {
      var body = json.decode(response.body) as List;
      return body.map((item) => Supplies.fromJson(item)).toList();
    } else {
      print("list(): ${response.statusCode}");
    }
  }

  Future<bool> post(Supplies supplies) async {
    var response = await http.post(baseUrl + "/supplies", body: json.encode(supplies));
    if (response.statusCode == 201) {
      return true;
    } else {
      print("post(): ${response.statusCode}");
      return false;
    }
  }

  Future<bool> put(Supplies supplies) async {
    var response = await http.put(baseUrl + "/supplies", body: json.encode(supplies));
    if (response.statusCode == 204) {
      return true;
    } else {
      print("put(): ${response.statusCode}");
      return false;
    }
  }

  Future<List<Supplies>> find_all_supplies(var eventId) async {
    var url = baseUrl + "/supplies/" + eventId;
    print("Retrieving supplies from: $url");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response from find_all_supplies: ${response.body}");
      var body = json.decode(response.body) as List;
      return body.map((item) => Supplies.fromJson(item)).toList();
    } else {
      print("find_all_supplies(): ${response.statusCode}");
      return null;
    }
  }

  Future <Supplies> find(var eventId, var suppliesId) async {
    var response = await http.get(baseUrl + "/supplies/" + eventId + "/" + suppliesId);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return Supplies.fromJson(body);
    } else {
      print("find(): ${response.statusCode}");
      return null;
    }
  }

  Future<bool> delete(var eventId, var suppliesId) async {
    var response = await http.delete(baseUrl + "/supplies/" + eventId + "/" + suppliesId);
    if (response.statusCode == 204) {
      return true;
    } else {
      print("delete(): ${response.statusCode}");
      return false;
    }
  }
}

void main() async { //for Testing
  var service = SuppliesService();
  
  var supplies = await service.list();
  print("List: $supplies");

  var findsupplies = await service.find("1", "1");
  print("Found specific supply: $findsupplies");

  var findallsupplies = await service.find_all_supplies("1");
  print("Found all supplies for Event 1: $findallsupplies");

  findsupplies.supply_name = "Tool";
  var status = await service.put(findsupplies);
  print("Update Status: $status");

  var deleteStatus = await service.delete(findsupplies.event_id, findsupplies.supplies_id);
  print("Delete Status: $deleteStatus");

  var createStatus = await service.post(findsupplies);
  print("Create Status: $createStatus");
}
