import 'package:dio/dio.dart';
import 'package:stock_management_tool/core/resources/application_error.dart';
import 'package:stock_management_tool/core/resources/data_state.dart';

class NetworkServices {
  String localUrl = "http://localhost:3000";
  String cloudUrl = "http://18.170.161.164:3000";

  late String currentURL;

  final Dio _dio = Dio();

  void setToLocalEnv() {
    currentURL = localUrl;
  }

  void setToCloudEnv() {
    currentURL = cloudUrl;
  }

  Future<DataState> get(String path) async {
    try {
      Response response = await _dio.get("$currentURL/$path");

      if (response.statusCode == 200) {
        var jsonData = response.data;

        return DataSuccess(jsonData);
      }
    } catch (error) {
      const DataFailed(ServerError(message: "Server Error"));
    }
    return const DataFailed(UnknownError(message: "Unknown Error"));
  }

  Future<DataState> post(String path, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post("$currentURL/$path", data: data);

      if (response.statusCode == 201) {
        var jsonData = response.data;

        return DataSuccess(jsonData);
      }
    } catch (error) {
      const DataFailed(ServerError(message: "Server Error"));
    }
    return const DataFailed(UnknownError(message: "Unknown Error"));
  }

  Future<DataState> postBatch(String path, Map<String, dynamic> data) async {
    try {
      Response response =
          await _dio.post("$currentURL/$path/batch", data: data);

      if (response.statusCode == 201) {
        var jsonData = response.data;

        return DataSuccess(jsonData);
      }
    } catch (error) {
      const DataFailed(ServerError(message: "Server Error"));
    }
    return const DataFailed(UnknownError(message: "Unknown Error"));
  }

  Future<DataState> patch(String path, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.patch("$currentURL/$path", data: data);

      if (response.statusCode == 200) {
        var jsonData = response.data;

        return DataSuccess(jsonData);
      }
    } catch (error) {
      const DataFailed(ServerError(message: "Server Error"));
    }
    return const DataFailed(UnknownError(message: "Unknown Error"));
  }

  Future<DataState> patchBatch(String path, Map<String, dynamic> data) async {
    try {
      Response response =
          await _dio.patch("$currentURL/$path/batch", data: data);

      if (response.statusCode == 200) {
        var jsonData = response.data;

        return DataSuccess(jsonData);
      }
    } catch (error) {
      const DataFailed(ServerError(message: "Server Error"));
    }
    return const DataFailed(UnknownError(message: "Unknown Error"));
  }

  Future<DataState> delete(String path, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.delete("$currentURL/$path", data: data);

      if (response.statusCode == 200) {
        var jsonData = response.data;

        return DataSuccess(jsonData);
      }
    } catch (error) {
      const DataFailed(ServerError(message: "Server Error"));
    }
    return const DataFailed(UnknownError(message: "Unknown Error"));
  }

  Future<DataState> deleteBatch(String path, Map<String, dynamic> data) async {
    try {
      Response response =
          await _dio.delete("$currentURL/$path/batch", data: data);

      if (response.statusCode == 200) {
        var jsonData = response.data;

        return DataSuccess(jsonData);
      }
    } catch (error) {
      const DataFailed(ServerError(message: "Server Error"));
    }
    return const DataFailed(UnknownError(message: "Unknown Error"));
  }

  Future<DataState> query(String path, Map<String, dynamic> data) async {
    try {
      Response response =
          await _dio.post("$currentURL/$path/query", data: data);

      if (response.statusCode == 200) {
        var jsonData = response.data;

        return DataSuccess(jsonData);
      }
    } catch (error) {
      const DataFailed(ServerError(message: "Server Error"));
    }
    return const DataFailed(UnknownError(message: "Unknown Error"));
  }
}
