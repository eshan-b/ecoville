import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoville/service/user_crud.dart';
import 'event_model.dart';
import 'dart:async';

import 'user_model.dart';

class EventService {
  final CollectionReference ref = Firestore.instance.collection("events");
  final UserService userService = UserService();
  Future<EventModel> findByField({var fieldName, var fieldValue}) async {
    QuerySnapshot query = await ref.where(fieldName, isEqualTo: fieldValue).getDocuments();
    List<EventModel> eventModels = query.documents
      .map((snapshot) { 
          return EventModel.fromJson(snapshot.documentID, snapshot.data);
          /*userService.find(snapshot.data['lead_user']).then((UserModel leadUser) {
            return EventModel.fromJson(snapshot.documentID, leadUser, snapshot.data);
          });*/
        })
      .toList();
    if (eventModels.length > 0) {
      return eventModels[0];
    } else {
      return null;
    }
  }

  /* CRUD Operations */
  Future<EventModel> find(var documentID) async {
    DocumentSnapshot snapshot = await ref.document(documentID).get();
    //UserModel leadUser = await userService.find(snapshot.data['lead_user']);
    return EventModel.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<void> create(EventModel eventModel) async {
    await ref.add(eventModel.toJson());
  }

  Future<void> update(var documentID, EventModel eventModel) async {
    await ref.document(documentID).updateData(eventModel.toJson());
  }

  Future<void> delete(var documentID) async {
    await ref.document(documentID).delete();
  }

  Stream<List<EventModel>> list() {
    return ref.orderBy('posted_date').snapshots().map((QuerySnapshot query) => query
      .documents
      .map((snapshot) {
        return EventModel.fromJson(snapshot.documentID, snapshot.data);
        /*userService.find(snapshot.data['lead_user']).then((UserModel leadUser) {
          return EventModel.fromJson(snapshot.documentID, leadUser, snapshot.data);
        });*/
      }).toList()
    );
  }
}
