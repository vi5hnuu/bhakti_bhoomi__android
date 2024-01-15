import 'package:bhakti_bhoomi/models/UserInfo.dart';

class LoginResponse {
  final String message;
  final UserInfo? data;
  final bool success;
  LoginResponse({required this.message, this.data, required this.success});

  factory LoginResponse.fromJson(Map<String, dynamic> loginResponse) {
    return LoginResponse(
      message: loginResponse['message'],
      data: loginResponse['data'] != null
          ? UserInfo.fromJson(loginResponse['data'])
          : null,
      success: loginResponse['success'],
    );
  }
}
