import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/services/firestore_default.dart';
import 'package:stock_management_tool/services/firestore_rest_api.dart';

class Firestore {
  Future<List> getDocuments({
    required String path,
    bool includeDocRef = false,
    bool includeUpdateTime = false,
  }) async {
    List data;
    if (!kIsLinux) {
      data = await sl.get<FirestoreDefault>().getDocuments(
            path: path,
          );
    } else {
      data = (await sl.get<FirestoreRestApi>().getDocuments(
                path: path,
                includeDocRef: includeDocRef,
                includeUpdateTime: includeUpdateTime,
              ))
          .data;
    }
    return data;
  }

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

  Future<List> filterQuery({required String path, required Map query}) async {
    List data;
    if (!kIsLinux) {
      data = await sl.get<FirestoreDefault>().filterQuery(path: path, query: query);
    } else {
      data = (await sl.get<FirestoreRestApi>().filterQuery(path: path, query: query)).data;
    }

    return data;
  }
}
