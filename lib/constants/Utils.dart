import 'package:dio/dio.dart';

class Utils {
  static String? handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return null;
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return "please check your internet connection.";
      default:
        return e.message;
    }
  }
}
