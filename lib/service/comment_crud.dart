import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment_model.dart';
import 'dart:async';

class CommentService {
  var eventId;
  CollectionReference ref;

  CommentService(var eventId) { 
    this.eventId = eventId;
    this.ref = Firestore.instance.collection("events").document(eventId).collection("comments");
  }

  Future<CommentModel> findByField({var fieldName, var fieldValue}) async {
    QuerySnapshot query = await ref.where(fieldName, isEqualTo: fieldValue).getDocuments();
    List<CommentModel> commentModels = query.documents
      .map(
        (snapshot) => CommentModel.fromJson(snapshot.documentID, snapshot.data)
      )
      .toList();
    if (commentModels.length > 0) {
      return commentModels[0];
    } else {
      return null;
    }
  }

  /* CRUD Operations */
  Future<CommentModel> find(var documentID) async {
    DocumentSnapshot snapshot = await ref.document(documentID).get();
    return CommentModel.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<void> create(CommentModel commentModel) async {
    commentModel.event_id = this.eventId;
    await ref.add(commentModel.toJson());
    print("Created Comment for Eventid: $eventId");
  }

  Future<void> update(var documentID, CommentModel commentModel) async {
    await ref.document(documentID).updateData(commentModel.toJson());
  }

  Future<void> delete(var documentID) async {
    await ref.document(documentID).delete();
  }

  Stream<List<CommentModel>> list() {
    print("Query comments for event: $eventId");
    return ref.orderBy("posted_date").snapshots().map((QuerySnapshot query) => query
      .documents
      .map((snapshot) => CommentModel.fromJson(snapshot.documentID, snapshot.data))
      .toList()
    );
  }
}
