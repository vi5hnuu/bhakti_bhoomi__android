import 'package:bhakti_bhoomi/models/UserRole.dart';
import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class AuthApi {
  static final AuthApi _instance = AuthApi._();

  static final String _loginUrl = "${ApiConstants.baseUrl}/users/login"; //POST
  static final String _registerUrl = "${ApiConstants.baseUrl}/users/login"; //POST
  // static final String _verifyUrl = "${ApiConstants.baseUrl}/users/verify"; //GET (done on email itself)
  static final String _reVerifyUrl = "${ApiConstants.baseUrl}/users/re-verify"; //GET
  static final String _forgotPasswordUrl = "${ApiConstants.baseUrl}/users/forgot-password"; //POST
  static final String _resetPaswordUrl = "${ApiConstants.baseUrl}/users/reset-password"; //POST
  static final String _updateProfileImageUrl = "${ApiConstants.baseUrl}/users/profile"; //POST
  static final String _updatePosterImageUrl = "${ApiConstants.baseUrl}/users/poster"; //POST
  static final String _logoutUrl = "${ApiConstants.baseUrl}/users/logout"; //GET
  static final String _meUrl = "${ApiConstants.baseUrl}/users/me"; //GET
  static final String _deleteMeUrl = "${ApiConstants.baseUrl}/users"; //DELETE
  static final String _updatePasswordUrl = "${ApiConstants.baseUrl}/users/password"; //PATCH

  //admin
  static final String _allUsersUrl = "${ApiConstants.baseUrl}/users/all"; //GET
  static final String _deleteUserUrl = "${ApiConstants.baseUrl}/users"; //DELETE
  static final String _getUserUrl = "${ApiConstants.baseUrl}/users"; //GET
  static final String _addRoleUrl = "${ApiConstants.baseUrl}/users/add-role"; //PATCH

  AuthApi._();
  factory AuthApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> login({required String usernameEmail, required String password}) async {
    var res = await Dio().post(_loginUrl, data: {
      "usernameEmail": usernameEmail,
      "password": password,
    });
    return res.data;
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
    required XFile profileImage,
    required XFile posterImage,
  }) async {
    FormData formData = FormData.fromMap({
      "userInfo": {
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
        "email": email,
        "password": password,
      },
      "profileImage": await MultipartFile.fromFile(profileImage.path, filename: profileImage.name),
      "posterImage": await MultipartFile.fromFile(posterImage.path, filename: posterImage.name),
    });
    var res = await Dio().post(_registerUrl, data: formData);
    return res.data;
  }

  Future<Map<String, dynamic>> reVerify({required String email}) async {
    var res = await Dio().get('$_reVerifyUrl?email=$email');
    return res.data;
  }

  Future<Map<String, dynamic>> forgotPassword({required String usernameEmail}) async {
    var res = await Dio().post(_forgotPasswordUrl, data: {"usernameEmail": usernameEmail});
    return res.data;
  }

  Future<Map<String, dynamic>> resetPassword({required String usernameEmail, required String otp, required String password, required String confirmPassword}) async {
    var res = await Dio().post(_resetPaswordUrl, data: {"usernameEmail": usernameEmail, "otp": otp, "password": password, "confirmPassword": confirmPassword});
    return res.data;
  }

  Future<Map<String, dynamic>> updateProfilePic({required XFile profileImage}) async {
    final FormData formData = FormData.fromMap({"poster": await MultipartFile.fromFile(profileImage.path, filename: profileImage.name)});
    var res = await Dio().post(_updatePosterImageUrl, data: formData);
    return res.data;
  }

  Future<Map<String, dynamic>> updatePosterPic({required XFile posterImage}) async {
    final FormData formData = FormData.fromMap({"profile": await MultipartFile.fromFile(posterImage.path, filename: posterImage.name)});
    var res = await Dio().post(_updateProfileImageUrl, data: formData);
    return res.data;
  }

  Future<Map<String, dynamic>> logout() async {
    var res = await Dio().get(_logoutUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> me() async {
    var res = await Dio().get(_meUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> deleteMe() async {
    var res = await Dio().delete(_deleteMeUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> updatePassword({required String oldPassword, required String newPassword, required String confirmPassword}) async {
    var res = await Dio().patch(_updatePasswordUrl, data: {"oldPassword": oldPassword, "newPassword": newPassword, "confirmPassword": confirmPassword});
    return res.data;
  }

  Future<Map<String, dynamic>> getAllUsers({int? pageNo, int? pageSize}) async {
    String url = _allUsersUrl;
    if (pageNo != null) url = "$url?pageNo=$pageNo";
    if (pageSize != null) url = pageNo != null ? "$url&pageSize=$pageSize" : "$url?pageSize=$pageSize";
    var res = await Dio().get(url);
    return res.data;
  }

  Future<Map<String, dynamic>> deleteUser({required String userId}) async {
    var res = await Dio().delete('$_deleteUserUrl/$userId');
    return res.data;
  }

  Future<Map<String, dynamic>> getUser({required String userId}) async {
    var res = await Dio().get('$_getUserUrl/$userId');
    return res.data;
  }

  Future<Map<String, dynamic>> addRole({required String userId, required UserRole userRole}) async {
    var res = await Dio().patch('$_addRoleUrl', data: {
      "userId": userId,
      "role": userRole.role,
    });
    return res.data;
  }
}
