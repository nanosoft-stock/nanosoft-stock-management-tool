import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/services/firestore_default.dart';
import 'package:stock_management_tool/services/firestore_rest_api.dart';

class Firestore {
  Future<void> createDocument({required String path, required Map data}) async {
    if (!kIsLinux) {
      await sl.get<FirestoreDefault>().createDocument(
            path: path,
            data: data,
          );
    } else {
      await sl.get<FirestoreRestApi>().createDocument(
            path: path,
            data: data,
          );
    }
  }

  Future<List> getDocuments({
    required String path,
    bool includeUid = false,
    bool includeUpdateTime = false,
  }) async {
    List data;
    if (!kIsLinux) {
      data = await sl.get<FirestoreDefault>().getDocuments(
            path: path,
            includeUid: includeUid,
          );
    } else {
      data = (await sl.get<FirestoreRestApi>().getDocuments(
                path: path,
                includeUid: includeUid,
                includeUpdateTime: includeUpdateTime,
              ))
          .data;
    }
    return data;
  }

  Stream<QuerySnapshot> listenToDocumentChanges({required String path}) {
    // if (!kIsLinux) {
    return sl.get<FirestoreDefault>().listenToDocumentChanges(path: path);
    // }
  }

  Future<List> filterQuery({required String path, required Map query}) async {
    List data;
    if (!kIsLinux) {
      data = await sl
          .get<FirestoreDefault>()
          .filterQuery(path: path, query: query);
    } else {
      data = (await sl
              .get<FirestoreRestApi>()
              .filterQuery(path: path, query: query))
          .data;
    }

    return data;
  }

  Future<void> modifyDocument(
      {required String path,
      required String uid,
      List? updateMask,
      required Map data}) async {
    if (!kIsLinux) {
      await sl.get<FirestoreDefault>().modifyDocument(
            path: path,
            uid: uid,
            data: data,
          );
    } else {
      await sl.get<FirestoreRestApi>().modifyDocument(
            path: path,
            uid: uid,
            updateMask: updateMask,
            data: data,
          );
    }
  }

  Future<void> deleteDocument(
      {required String path, required String uid}) async {
    if (!kIsLinux) {
      await sl.get<FirestoreDefault>().deleteDocument(path: path, uid: uid);
    } else {
      await sl.get<FirestoreRestApi>().deleteDocument(path: path, uid: uid);
    }
  }

  Future<void> batchWrite({required String path, required List data}) async {
    if (!kIsLinux) {
      await sl.get<FirestoreDefault>().batchWrite(path: path, data: data);
    } else {}
  }
}
