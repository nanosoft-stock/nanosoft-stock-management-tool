import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_management_tool/helper/firebase_options.dart';

class FirestoreRestApi {
  static String apiKey = "";
  static String projectId = "";

  void fetchApiKey() {
    apiKey = DefaultFirebaseOptions.web.apiKey;
  }

  void fetchProjectId() {
    projectId = DefaultFirebaseOptions.web.projectId;
  }

  Future<List> getDocuments({required String path, bool includeDocRef = false}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body.trim());
        // print(jsonData);
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

        return data;
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

  Future<Map> getFields({required String path}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body.trim());
        // print(jsonData);
        var data = jsonData['fields'];
        return data;
      }
    } catch (e) {
      print("Error: $e");
    }
    return {};
  }

  Future<void> createDocument({required String path, required Map data}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            "fields": data,
          },
        ),
      );

      if (response.statusCode == 200) {
        // print(response.body.trim());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> filterQuery({required String path, required Map query}) async {
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

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            "structuredQuery": structuredQuery,
          },
        ),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body.trim());
        var data = jsonData.map((e) => e["document"]["name"].toString().split("/").last).toList();
        // print(data);
        return data;
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }
}
