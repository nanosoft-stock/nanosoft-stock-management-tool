import 'package:stock_management_tool/core/resources/application_error.dart';

abstract class DataState<T> {
  final T? data;
  final ApplicationError? error;

  const DataState({
    this.data,
    this.error,
  });
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(ApplicationError error) : super(error: error);
}
