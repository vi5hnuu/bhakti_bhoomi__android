import 'dart:convert';

import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/models/UserRole.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';
import 'package:dio/dio.dart';

class AuthApi {
  static final AuthApi _instance = AuthApi._();

  static const String _loginUrl = "${ApiConstants.baseUrl}/users/login"; //POST
  static const String _registerUrl = "${ApiConstants.baseUrl}/users/register"; //POST
  // static const String _verifyUrl = "${ApiConstants.baseUrl}/users/verify"; //GET (done on email itself)
  static const String _reVerifyUrl = "${ApiConstants.baseUrl}/users/re-verify"; //GET
  static const String _forgotPasswordUrl = "${ApiConstants.baseUrl}/users/forgot-password"; //POST
  static const String _resetPaswordUrl = "${ApiConstants.baseUrl}/users/reset-password"; //POST
  static const String _updateProfileImageUrl = "${ApiConstants.baseUrl}/users/profile"; //POST
  static const String _updatePosterImageUrl = "${ApiConstants.baseUrl}/users/poster"; //POST
  static const String _logoutUrl = "${ApiConstants.baseUrl}/users/logout"; //GET
  static const String _meUrl = "${ApiConstants.baseUrl}/users/me"; //GET
  static const String _deleteMeUrl = "${ApiConstants.baseUrl}/users"; //DELETE
  static const String _updatePasswordUrl = "${ApiConstants.baseUrl}/users/password"; //PATCH

  //admin
  static const String _allUsersUrl = "${ApiConstants.baseUrl}/users/all"; //GET
  static const String _deleteUserUrl = "${ApiConstants.baseUrl}/users"; //DELETE
  static const String _getUserUrl = "${ApiConstants.baseUrl}/users"; //GET
  static const String _addRoleUrl = "${ApiConstants.baseUrl}/users/add-role"; //PATCH

  AuthApi._();
  factory AuthApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> login({required String usernameEmail, required String password, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.post(_loginUrl,
        data: jsonEncode({
          "usernameEmail": usernameEmail,
          "password": password,
        }),
        cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> register(
      {required String firstName,
      required String lastName,
      required String userName,
      required String email,
      required String password,
      required MultipartFile profileImage,
      required MultipartFile posterImage,
      CancelToken? cancelToken}) async {
    FormData formData = FormData.fromMap({
      "userInfo": jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
        "email": email,
        "password": password,
      }),
      "profileImage": profileImage,
      "posterImage": posterImage,
    });
    var res = await DioSingleton().dio.post(_registerUrl, data: formData, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> reVerify({required String email, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_reVerifyUrl?email=$email', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> forgotPassword({required String usernameEmail, CancelToken? cancelToken}) async {
    try {
      var res = await DioSingleton().dio.post(_forgotPasswordUrl, data: jsonEncode({"usernameEmail": usernameEmail}), cancelToken: cancelToken);
      return res.data;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Map<String, dynamic>> resetPassword({required String usernameEmail, required String otp, required String password, required String confirmPassword, CancelToken? cancelToken}) async {
    var res = await DioSingleton()
        .dio
        .post(_resetPaswordUrl, data: jsonEncode({"usernameEmail": usernameEmail, "otp": otp, "password": password, "confirmPassword": confirmPassword}), cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> updateProfilePic({required MultipartFile profileImage, required String userId, CancelToken? cancelToken}) async {
    final FormData formData = FormData.fromMap({"poster": profileImage});
    var res = await DioSingleton().dio.post('$_updateProfileImageUrl/$userId', data: formData, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> updatePosterPic({required MultipartFile posterImage, required String userId, CancelToken? cancelToken}) async {
    final FormData formData = FormData.fromMap({"profile": posterImage});
    var res = await DioSingleton().dio.post('$_updatePosterImageUrl/$userId', data: formData, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> logout({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_logoutUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> me({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_meUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> deleteMe({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.delete(_deleteMeUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> updatePassword({required String oldPassword, required String newPassword, required String confirmPassword, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.patch(_updatePasswordUrl, data: {"oldPassword": oldPassword, "newPassword": newPassword, "confirmPassword": confirmPassword}, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getAllUsers({int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    String url = _allUsersUrl;
    if (pageNo != null) url = "$url?pageNo=$pageNo";
    if (pageSize != null) url = pageNo != null ? "$url&pageSize=$pageSize" : "$url?pageSize=$pageSize";
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> deleteUser({required String userId, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.delete('$_deleteUserUrl/$userId', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getUser({required String userId, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_getUserUrl/$userId', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> addRole({required String userId, required UserRole userRole, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.patch('$_addRoleUrl',
        data: {
          "userId": userId,
          "role": userRole.role,
        },
        cancelToken: cancelToken);
    return res.data;
  }
}
