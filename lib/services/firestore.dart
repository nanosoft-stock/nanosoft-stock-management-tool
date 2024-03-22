import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  final firestore = FirebaseFirestore.instance;

  Future<List> getDocuments({required String collection}) async {
    CollectionReference productListRef = firestore.collection(collection);

    QuerySnapshot snapshot = await productListRef.get();
    final data = snapshot.docs.map((doc) => doc.data()).toList();
    return data;
  }
}
