import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'event_signup_model.dart';

class SignupService {
  var eventId;
  CollectionReference ref;

  SignupService(var eventId) { 
    this.eventId = eventId;
    this.ref = Firestore.instance.collection("events").document(eventId).collection("signups");
  }

  Future<EventSignupModel> findByField({var fieldName, var fieldValue}) async {
    QuerySnapshot query = await ref.where(fieldName, isEqualTo: fieldValue).getDocuments();
    List<EventSignupModel> eventSignupModels = query.documents
      .map(
        (snapshot) => EventSignupModel.fromJson(snapshot.documentID, snapshot.data)
      )
      .toList();
    if (eventSignupModels.length > 0) {
      return eventSignupModels[0];
    } else {
      return null;
    }
  }

  /* CRUD Operations */
  Future<EventSignupModel> find(var documentID) async {
    DocumentSnapshot snapshot = await ref.document(documentID).get();
    return EventSignupModel.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<void> create(EventSignupModel eventSignupModel) async {
    eventSignupModel.event_id = this.eventId;
    await ref.add(eventSignupModel.toJson());
    print("Created EventSignup for Eventid: $eventId");
  }

  Future<void> update(var documentID, EventSignupModel eventSignupModel) async {
    await ref.document(documentID).updateData(eventSignupModel.toJson());
  }

  Future<void> delete(var documentID) async {
    await ref.document(documentID).delete();
  }

  Stream<List<EventSignupModel>> list() {
    print("Query event signup for event: $eventId");
    return ref.snapshots().map((QuerySnapshot query) => query
      .documents
      .map((snapshot) => EventSignupModel.fromJson(snapshot.documentID, snapshot.data))
      .toList()
    );
  }
}
