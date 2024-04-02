import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDefault {
  final firestore = FirebaseFirestore.instance;

  Future<List> getDocuments({required String path}) async {
    CollectionReference collectionRef = firestore.collection(path);

    QuerySnapshot snapshot = await collectionRef.get();
    final data = snapshot.docs.map((doc) => doc.data()).toList();
    return data;
  }

  Future<void> createDocument({required String path, required Map data}) async {
    CollectionReference collectionRef = firestore.collection(path);
    await collectionRef.add(data.cast<String, dynamic>());
  }

  Future<List> filterQuery({required String path, required Map query}) async {
    CollectionReference collectionRef = firestore.collection(path);

    QuerySnapshot? snapshot;

    if (query["where"] != null) {
      if (query["where"]["op"] == "isEqualTo") {
        snapshot = await collectionRef
            .where(query["where"]["field"], isEqualTo: query["where"]["value"])
            .get();
      }
    }

    final data = snapshot!.docs.map((doc) => doc.id).toList();
    return data;
  }
}
