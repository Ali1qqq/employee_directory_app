import 'package:dio/dio.dart';

import 'failure.dart';

sealed class AppException implements Exception {
  const AppException();
}

class DioAppException extends AppException {
  final DioException error;

  const DioAppException(this.error);
}

class SocketAppException extends AppException {
  const SocketAppException();
}


class FailureAppException extends AppException {
  final Failure failure;

  const FailureAppException(this.failure);
}

class UnknownAppException extends AppException {
  final dynamic error;

  const UnknownAppException(this.error);
}