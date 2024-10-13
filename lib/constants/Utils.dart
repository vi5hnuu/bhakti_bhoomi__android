import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:dio/dio.dart';

class Utils {
  static ErrorModel? handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return null;
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ErrorModel(message: "Please check your internet connection.",statusCode: e.response?.statusCode);
      case DioExceptionType.badResponse:
        return ErrorModel(message: e.response?.data?['message'] ?? 'something went wrong',statusCode: e.response?.statusCode);
      default:
        return ErrorModel(message: e.response?.data['message'] ?? e.message,statusCode: e.response?.statusCode);
    }
  }
  static String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);

    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return "$hours:$minutes:$secs";
  }
}
