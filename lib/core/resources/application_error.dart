abstract class ApplicationError {
  const ApplicationError({required this.message});

  final String message;

  @override
  String toString() {
    return "ApplicationError(message: $message)";
  }
}

class NetworkError extends ApplicationError {
  const NetworkError({required super.message});

  @override
  String toString() {
    return "NetworkError(message: $message)";
  }
}

class InternalError extends ApplicationError {
  const InternalError({required super.message});

  @override
  String toString() {
    return "InternalError(message: $message)";
  }
}

class ServerError extends ApplicationError {
  const ServerError({required super.message});

  @override
  String toString() {
    return "ServerError(message: $message)";
  }
}

class ValidationError extends ApplicationError {
  const ValidationError({required super.message});

  @override
  String toString() {
    return "ValidationError(message: $message)";
  }
}

class UnknownError extends ApplicationError {
  const UnknownError({required super.message});

  @override
  String toString() {
    return "UnknownError(message: $message)";
  }
}
