import 'package:bhakti_bhoomi/models/UserInfo.dart';
import 'package:bhakti_bhoomi/models/response/UsersPage.dart';

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  const ApiResponse({required this.success, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> rawData) {
    if (T == UserInfo) {
      return ApiResponse<T>(
        success: rawData['success'],
        message: rawData['message'],
        data: UserInfo.fromJson(rawData['data']) as T,
      );
    } else if (T == UsersPage) {
      return ApiResponse<T>(
        success: rawData['success'],
        message: rawData['message'],
        data: UsersPage.fromJson(rawData['data']) as T,
      );
    }
    throw Exception('ApiResponse.fromJson: Unknown type');
  }
}
