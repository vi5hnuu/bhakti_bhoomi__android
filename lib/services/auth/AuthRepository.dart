import 'package:bhakti_bhoomi/models/UserInfo.dart';
import 'package:bhakti_bhoomi/models/UserRole.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/response/UsersPage.dart';
import 'package:bhakti_bhoomi/services/apis/AuthApi.dart';
import 'package:dio/dio.dart';

import 'AuthService.dart';

class AuthRepository implements AuthService {
  final AuthApi _authApi;
  static final AuthRepository _instance = AuthRepository._();

  AuthRepository._() : _authApi = AuthApi();
  factory AuthRepository() => _instance;

  @override
  Future<ApiResponse> addRole({required String userId, required UserRole userRole, CancelToken? cancelToken}) async {
    var res = await _authApi.addRole(userId: userId, userRole: userRole, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse> deleteMe({CancelToken? cancelToken}) async {
    var res = await _authApi.deleteMe(cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse> deleteUser({required String userId, CancelToken? cancelToken}) async {
    var res = await _authApi.deleteUser(userId: userId, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse> forgotPassword({required String usernameEmail, CancelToken? cancelToken}) async {
    var res = await _authApi.forgotPassword(usernameEmail: usernameEmail, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse<UsersPage>> getAllUsers({int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    var res = await _authApi.getAllUsers(pageNo: pageNo, pageSize: pageSize, cancelToken: cancelToken);
    return ApiResponse<UsersPage>(success: res['success'], message: res['message'], data: UsersPage.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<UserInfo>> getUser({required String userId, CancelToken? cancelToken}) async {
    var res = await _authApi.getUser(userId: userId, cancelToken: cancelToken);
    return ApiResponse<UserInfo>(success: res['success'], message: res['message'], data: UserInfo.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<UserInfo>> login({required String usernameEmail, required String password, CancelToken? cancelToken}) async {
    var res = await _authApi.login(usernameEmail: usernameEmail, password: password, cancelToken: cancelToken);
    return ApiResponse<UserInfo>(success: res['success'], message: res['message'], data: UserInfo.fromJson(res['data']));
  }

  @override
  Future<ApiResponse> logout({CancelToken? cancelToken}) async {
    var res = await _authApi.logout(cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse<UserInfo>> me({CancelToken? cancelToken}) async {
    var res = await _authApi.me(cancelToken: cancelToken);
    return ApiResponse<UserInfo>(success: res['success'], message: res['message'], data: UserInfo.fromJson(res['data']));
  }

  @override
  Future<ApiResponse> reVerify({required String email, CancelToken? cancelToken}) async {
    var res = await _authApi.reVerify(email: email, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse> register(
      {required String firstName,
      required String lastName,
      required String userName,
      required String email,
      required String password,
      required MultipartFile profileImage,
      required MultipartFile posterImage,
      CancelToken? cancelToken}) async {
    var res = await _authApi.register(
        email: email, firstName: firstName, lastName: lastName, password: password, posterImage: posterImage, profileImage: profileImage, userName: userName, cancelToken: cancelToken);
    return ApiResponse<UserInfo>(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse> resetPassword({required String usernameEmail, required String otp, required String password, required String confirmPassword, CancelToken? cancelToken}) async {
    var res = await _authApi.resetPassword(usernameEmail: usernameEmail, otp: otp, password: password, confirmPassword: confirmPassword, cancelToken: cancelToken);
    return ApiResponse<UserInfo>(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse> updatePassword({required String oldPassword, required String newPassword, required String confirmPassword, CancelToken? cancelToken}) async {
    var res = await _authApi.updatePassword(confirmPassword: confirmPassword, newPassword: newPassword, oldPassword: oldPassword, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse> updatePosterPic({required MultipartFile posterImage, required String userId, CancelToken? cancelToken}) async {
    var res = await _authApi.updatePosterPic(posterImage: posterImage, userId: userId, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  @override
  Future<ApiResponse> updateProfilePic({required MultipartFile profileImage, required String userId, CancelToken? cancelToken}) async {
    var res = await _authApi.updateProfilePic(profileImage: profileImage, userId: userId, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }
}
