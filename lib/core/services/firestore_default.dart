import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDefault {
  final firestore = FirebaseFirestore.instance;

  Future<String> createDocument(
      {required String path, required Map data}) async {
    CollectionReference collectionRef = firestore.collection(path);

    return (await collectionRef.add(data.cast<String, dynamic>())).id;
  }

  Future<List> getDocuments(
      {required String path, bool includeUid = false}) async {
    CollectionReference collectionRef = firestore.collection(path);

    QuerySnapshot snapshot = await collectionRef.get();
    final data = snapshot.docs.map((doc) {
      final data = doc.data() as Map;
      if (includeUid) data["uid"] = doc.reference.id;

      return data;
    }).toList();

    return data;
  }

  Stream<QuerySnapshot> listenToDocumentChanges({required String path}) {
    CollectionReference collectionRef = firestore.collection(path);
    return collectionRef.snapshots();
  }

  Future<List> filterQuery({required String path, required Map query}) async {
    CollectionReference collectionRef =
        firestore.collection(query["from"].first["collectionId"]);

    QuerySnapshot? snapshot;

    if (query["where"] != null) {
      if (query["where"]["fieldFilter"]["op"] == "EQUAL") {
        snapshot = await collectionRef
            .where(query["where"]["fieldFilter"]["field"]["fieldPath"],
                isEqualTo: query["where"]["fieldFilter"]["value"].values.first)
            .get();
      }
    }

    final data = snapshot!.docs.map((e) {
      Map map = e.data() as Map;
      map["docRef"] = e.id;

      return map;
    }).toList();
    return data;
  }

  Future<void> modifyDocument(
      {required String path, required String uid, required Map data}) async {
    DocumentReference docRef = firestore.collection(path).doc(uid);
    await docRef.update(data.cast<String, dynamic>());
  }

  Future<void> deleteDocument(
      {required String path, required String uid}) async {
    DocumentReference docRef = firestore.collection(path).doc(uid);
    await docRef.delete();
  }

  Future<Map<String, dynamic>> batchWrite(
      {required String path,
      required List data,
      required bool isToBeUpdated}) async {
    int chunkSize = 500;

    Map<String, dynamic> docRefData = {};

    for (int i = 0; i < data.length; i = i + chunkSize) {
      WriteBatch batch = firestore.batch();
      List chunkData = data.sublist(
          i, data.length > i + chunkSize ? i + chunkSize : data.length);

      for (var e in chunkData) {
        try {
          if (!isToBeUpdated) {
            var docRef = firestore.collection(path).doc();
            if (path == "stock_data") {
              docRefData[e["item id"]] = {
                "container_id": e["container id"],
                "doc_ref": docRef.id,
              };
            }

            batch.set(docRef, e.cast<String, dynamic>());
          } else {
            batch.update(firestore.collection(path).doc(e["doc_ref"]),
                (e..remove("doc_ref")).cast<String, dynamic>());
          }
        } catch (e) {
          debugPrint(e.toString());
          return {};
        }
      }

      await batch.commit();
    }
    return docRefData;
  }
}
