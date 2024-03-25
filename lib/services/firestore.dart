import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  final firestore = FirebaseFirestore.instance;

  Future<List> getDocuments({
    required String path,
  }) async {
    CollectionReference collectionRef = firestore.collection(path);

    QuerySnapshot snapshot = await collectionRef.get();
    final data = snapshot.docs.map((doc) => doc.data()).toList();
    return data;
  }

  Future<List> filterQuery({
    required String path,
    required field,
    required isEqualTo,
  }) async {
    CollectionReference collectionRef = firestore.collection(path);

    QuerySnapshot snapshot = await collectionRef.where(field, isEqualTo: isEqualTo).get();
    final data = snapshot.docs.map((doc) => doc.id).toList();
    return data;
  }

  Future<void> createDocument({
    required String path,
    required Map data,
  }) async {
    CollectionReference collectionRef = firestore.collection(path);
    await collectionRef.add(data.cast<String, dynamic>());
  }
}
