import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/services/firestore_default.dart';
import 'package:stock_management_tool/services/firestore_rest_api.dart';

class Firestore {
  Future<List> getDocuments({required String path, bool includeDocRef = false}) async {
    List data;
    if (!kIsDesktop) {
      data = await FirestoreDefault().getDocuments(
        path: path,
      );
    } else {
      data = (await FirestoreRestApi().getDocuments(
        path: path,
        includeDocRef: includeDocRef,
      ))
          .data;
    }
    return data;
  }

  Future<void> createDocument({required String path, required Map data}) async {
    if (!kIsDesktop) {
      await FirestoreDefault().createDocument(
        path: path,
        data: data,
      );
    } else {
      await FirestoreRestApi().createDocument(
        path: path,
        data: data,
      );
    }
  }

  Future<List> filterQuery({required String path, required Map query}) async {
    List data;
    if (!kIsDesktop) {
      data = await FirestoreDefault().filterQuery(path: path, query: query);
    } else {
      data = (await FirestoreRestApi().filterQuery(path: path, query: query)).data;
    }

    return data;
  }
}
