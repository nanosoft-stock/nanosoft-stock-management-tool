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

  Future<DataState> getDocuments({required String path, bool includeDocRef = false}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";

      Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        var jsonData = response.data;
        List data = [];
        if (includeDocRef) {
          data = jsonData['documents'] != null
              ? jsonData['documents'].map(
                  (element) {
                    Map map = element['fields'];
                    map["docRef"] = {"stringValue": element['name'].toString().split('/').last};

                    return map;
                  },
                ).toList()
              : [];
        } else {
          data = jsonData['documents'] != null
              ? jsonData['documents'].map((e) => e['fields']).toList()
              : [];
        }
        return DataSuccess(data);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> createDocument({required String path, required Map data}) async {
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
        var data = jsonData['fields'];
        return DataSuccess(data);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> filterQuery({required String path, required Map query}) async {
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
        var data = jsonData.map((e) => e["document"]["name"].toString().split("/").last).toList();
        return DataSuccess(data);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }
}
