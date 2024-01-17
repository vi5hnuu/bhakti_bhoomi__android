import 'package:bhakti_bhoomi/models/UserInfo.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/response/UsersPage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/UserRole.dart';

abstract class AuthService {
  Future<ApiResponse<UserInfo>> login(String usernameEmail, String password);
  Future<ApiResponse> register({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
    required XFile profileImage,
    required XFile posterImage,
  });
  Future<ApiResponse> reVerify({required String email});
  Future<ApiResponse> forgotPassword({required String usernameEmail});
  Future<ApiResponse> resetPassword({required String usernameEmail, required String otp, required String password, required String confirmPassword});
  Future<ApiResponse> updateProfilePic({required XFile profileImage});
  Future<ApiResponse> updatePosterPic({required XFile posterImage});
  Future<ApiResponse> logout();
  Future<ApiResponse<UserInfo>> me();
  Future<ApiResponse> deleteMe();
  Future<ApiResponse> updatePassword({required String oldPassword, required String newPassword, required String confirmPassword});
  Future<ApiResponse<UsersPage>> getAllUsers({int? pageNo, int? pageSize});
  Future<ApiResponse> deleteUser({required String userId});
  Future<ApiResponse<UserInfo>> getUser({required String userId});
  Future<ApiResponse> addRole({required String userId, required UserRole userRole});
}
