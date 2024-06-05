import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDefault {
  final firestore = FirebaseFirestore.instance;

  Future<void> createDocument({required String path, required Map data}) async {
    CollectionReference collectionRef = firestore.collection(path);
    await collectionRef.add(data.cast<String, dynamic>());
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

  Future<void> batchWrite({required String path, required List data}) async {
    int chunkSize = 500;
    WriteBatch batch = firestore.batch();

    for (int i = 0; i < data.length; i = i + chunkSize) {
      List chunkData = data.sublist(
          i, data.length > i + chunkSize ? i + chunkSize : data.length);

      for (var e in chunkData) {
        try {
          batch.set(
              firestore.collection(path).doc(), e.cast<String, dynamic>());
        } catch (e) {
          print("Error: $e");
        }
      }

      batch.commit();
    }
  }
}
