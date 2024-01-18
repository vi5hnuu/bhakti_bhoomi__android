import 'package:bhakti_bhoomi/models/UserInfo.dart';
import 'package:bhakti_bhoomi/models/UserRole.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/response/UsersPage.dart';
import 'package:bhakti_bhoomi/services/apis/AuthApi.dart';
import 'package:bhakti_bhoomi/services/brahmaSutra/BrahmaSutraService.dart';
import 'package:image_picker/image_picker.dart';

class BrahmaSutraRepository implements BrahmaSutraService {
  final AuthApi authApi;
  static final BrahmaSutraRepository _instance = BrahmaSutraRepository._();

  BrahmaSutraRepository._() : authApi = AuthApi();
  factory BrahmaSutraRepository() => _instance;

  @override
  Future<ApiResponse> addRole({required String userId, required UserRole userRole}) async {
    var res = await authApi.addRole(userId: userId, userRole: userRole);
    return ApiResponse.fromJson(res);
  }

  @override
  Future<ApiResponse> deleteMe() async {
    var res = await authApi.deleteMe();
    return ApiResponse.fromJson(res);
  }

  @override
  Future<ApiResponse> deleteUser({required String userId}) async {
    var res = await authApi.deleteUser(userId: userId);
    return ApiResponse.fromJson(res);
  }

  @override
  Future<ApiResponse> forgotPassword({required String usernameEmail}) async {
    var res = await authApi.forgotPassword(usernameEmail: usernameEmail);
    return ApiResponse.fromJson(res);
  }

  @override
  Future<ApiResponse<UsersPage>> getAllUsers({int? pageNo, int? pageSize}) async {
    var res = await authApi.getAllUsers(pageNo: pageNo, pageSize: pageSize);
    return ApiResponse<UsersPage>.fromJson(res);
  }

  @override
  Future<ApiResponse<UserInfo>> getUser({required String userId}) async {
    var res = await authApi.getUser(userId: userId);
    return ApiResponse<UserInfo>.fromJson(res);
  }

  @override
  Future<ApiResponse<UserInfo>> login(String usernameEmail, String password) async {
    var res = await authApi.login(usernameEmail: usernameEmail, password: password);
    return ApiResponse<UserInfo>.fromJson(res);
  }

  @override
  Future<ApiResponse> logout() async {
    var res = await authApi.logout();
    return ApiResponse.fromJson(res);
  }

  @override
  Future<ApiResponse<UserInfo>> me() async {
    var res = await authApi.me();
    return ApiResponse<UserInfo>.fromJson(res);
  }

  @override
  Future<ApiResponse> reVerify({required String email}) async {
    var res = await authApi.reVerify(email: email);
    return ApiResponse<UserInfo>.fromJson(res);
  }

  @override
  Future<ApiResponse> register(
      {required String firstName, required String lastName, required String userName, required String email, required String password, required XFile profileImage, required XFile posterImage}) async {
    var res = await authApi.register(email: email, firstName: firstName, lastName: lastName, password: password, posterImage: posterImage, profileImage: profileImage, userName: userName);
    return ApiResponse<UserInfo>.fromJson(res);
  }

  @override
  Future<ApiResponse> resetPassword({required String usernameEmail, required String otp, required String password, required String confirmPassword}) async {
    var res = await authApi.resetPassword(usernameEmail: usernameEmail, otp: otp, password: password, confirmPassword: confirmPassword);
    return ApiResponse<UserInfo>.fromJson(res);
  }

  @override
  Future<ApiResponse> updatePassword({required String oldPassword, required String newPassword, required String confirmPassword}) async {
    var res = await authApi.updatePassword(confirmPassword: confirmPassword, newPassword: newPassword, oldPassword: oldPassword);
    return ApiResponse<UserInfo>.fromJson(res);
  }

  @override
  Future<ApiResponse> updatePosterPic({required XFile posterImage}) async {
    var res = await authApi.updatePosterPic(posterImage: posterImage);
    return ApiResponse.fromJson(res);
  }

  @override
  Future<ApiResponse> updateProfilePic({required XFile profileImage}) async {
    var res = await authApi.updateProfilePic(profileImage: profileImage);
    return ApiResponse.fromJson(res);
  }
}
