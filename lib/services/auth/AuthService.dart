import 'package:bhakti_bhoomi/models/UserInfo.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/response/UsersPage.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/UserRole.dart';

abstract class AuthService {
  Future<ApiResponse<UserInfo>> login({required String usernameEmail, required String password, CancelToken? cancelToken});
  Future<ApiResponse> register(
      {required String firstName,
      required String lastName,
      required String userName,
      required String email,
      required String password,
      required MultipartFile profileImage,
      required MultipartFile posterImage,
      CancelToken? cancelToken});
  Future<ApiResponse> reVerify({required String email, CancelToken? cancelToken});
  Future<ApiResponse> forgotPassword({required String usernameEmail, CancelToken? cancelToken});
  Future<ApiResponse> resetPassword({required String usernameEmail, required String otp, required String password, required String confirmPassword, CancelToken? cancelToken});
  Future<ApiResponse> updateProfilePic({required XFile profileImage, CancelToken? cancelToken});
  Future<ApiResponse> updatePosterPic({required XFile posterImage, CancelToken? cancelToken});
  Future<ApiResponse> logout({CancelToken? cancelToken});
  Future<ApiResponse<UserInfo>> me({CancelToken? cancelToken});
  Future<ApiResponse> deleteMe({CancelToken? cancelToken});
  Future<ApiResponse> updatePassword({required String oldPassword, required String newPassword, required String confirmPassword, CancelToken? cancelToken});
  Future<ApiResponse<UsersPage>> getAllUsers({int? pageNo, int? pageSize, CancelToken? cancelToken});
  Future<ApiResponse> deleteUser({required String userId, CancelToken? cancelToken});
  Future<ApiResponse<UserInfo>> getUser({required String userId, CancelToken? cancelToken});
  Future<ApiResponse> addRole({required String userId, required UserRole userRole, CancelToken? cancelToken});
}
