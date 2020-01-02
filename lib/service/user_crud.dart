import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';
import 'dart:async';

class UserService {
  final CollectionReference ref = Firestore.instance.collection("users");

  Future<UserModel> findByField({var fieldName, var fieldValue}) async {
    QuerySnapshot query = await ref.where(fieldName, isEqualTo: fieldValue).getDocuments();
    List<UserModel> userModels = query.documents
      .map(
        (snapshot) => UserModel.fromJson(snapshot.documentID, snapshot.data)
      )
      .toList();
    if (userModels.length > 0) {
      return userModels[0];
    } else {
      return null;
    }
  }

  /* CRUD Operations */
  Future<UserModel> find(var documentID) async {
    DocumentSnapshot snapshot = await ref.document(documentID).get();
    return UserModel.fromJson(snapshot.documentID, snapshot.data);
  }

  Future<void> create(UserModel eventModel) async {
    await ref.add(eventModel.toJson());
  }

  Future<void> update(var documentID, UserModel eventModel) async {
    await ref.document(documentID).updateData(eventModel.toJson());
  }

  Future<void> delete(var documentID) async {
    await ref.document(documentID).delete();
  }

  Stream<List<UserModel>> list() {
    return ref.snapshots().map((QuerySnapshot query) => query
      .documents
      .map((snapshot) => UserModel.fromJson(snapshot.documentID, snapshot.data))
      .toList()
    );
  }
}
