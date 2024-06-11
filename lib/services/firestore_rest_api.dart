import 'package:dio/dio.dart';
import 'package:stock_management_tool/core/resources/data_state.dart';
import 'package:stock_management_tool/helper/firebase_options.dart';

class FirestoreRestApi {
  static String apiKey = "";
  static String projectId = "";
  final Dio _dio = Dio();

  void fetchApiKeyAndProjectId() {
    apiKey = DefaultFirebaseOptions.web.apiKey;
    projectId = DefaultFirebaseOptions.web.projectId;
  }

  Future<DataState> createDocument(
      {required String path, required Map data}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";

      Response response = await _dio.post(
        url,
        data: {
          "fields": data,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        var data = jsonData["name"].toString().split("/").last;

        return DataSuccess(data);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> getDocuments({
    required String path,
    bool includeUid = false,
    bool includeUpdateTime = false,
  }) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";

      Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        var jsonData = response.data;
        List data = [];
        data = jsonData['documents'] != null
            ? jsonData['documents'].map(
                (element) {
                  Map map = element['fields'];
                  if (includeUid) {
                    map["uid"] = {
                      "stringValue": element['name'].toString().split('/').last
                    };
                  }
                  if (includeUpdateTime) {
                    map["updateTime"] = element["updateTime"];
                  }

                  return map;
                },
              ).toList()
            : [];

        return DataSuccess(data);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> filterQuery(
      {required String path, required Map query}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents${path != '' ? '/$path' : ''}:runQuery?key=$apiKey";

      Map structuredQuery = {};

      if (query["select"] != null) {
        structuredQuery["select"] = query["select"];
      }
      if (query["from"] != null) {
        structuredQuery["from"] = query["from"];
      }
      if (query["where"] != null) {
        structuredQuery["where"] = query["where"];
      }
      if (query["orderBy"] != null) {
        structuredQuery["orderBy"] = query["orderBy"];
      }
      if (query["startAt"] != null) {
        structuredQuery["startAt"] = query["startAt"];
      }
      if (query["endAt"] != null) {
        structuredQuery["endAt"] = query["endAt"];
      }

      Response response = await _dio.post(
        url,
        data: {
          "structuredQuery": structuredQuery,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;

        var data = jsonData.map((e) {
          if (e["document"] != null) {
            Map map = e["document"]["fields"];
            map["uid"] = {
              "stringValue": e["document"]["name"].toString().split("/").last,
            };

            return map;
          } else {
            return {};
          }
        }).toList();

        return DataSuccess(data);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> modifyDocument(
      {required String path,
      required String uid,
      List? updateMask,
      required Map data}) async {
    try {
      String updateMaskUrl = "";

      if (updateMask != null && updateMask.isNotEmpty) {
        for (var element in updateMask) {
          updateMaskUrl = "${updateMaskUrl}updateMask.fieldPaths=$element&";
        }
      }

      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path/$uid?${updateMaskUrl}key=$apiKey";

      Response response = await _dio.patch(
        url,
        data: {
          "fields": data,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        var data = jsonData['fields'];

        return DataSuccess(data);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> deleteDocument(
      {required String path, required String uid}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path/$uid?key=$apiKey";

      Response response = await _dio.delete(url);

      if (response.statusCode == 200) {
        return const DataSuccess(true);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }
}
