part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  final CancelToken? cancelToken;
  const AuthEvent({this.cancelToken});
}

class LoginEvent extends AuthEvent {
  final String usernameEmail;
  final String password;

  const LoginEvent({required this.usernameEmail, required this.password, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class TryAuthenticatingEvent extends AuthEvent {
  const TryAuthenticatingEvent();
}

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final MultipartFile profilePic;
  final MultipartFile posterPic;

  const RegisterEvent(
      {required this.firstName,
      required this.lastName,
      required this.username,
      required this.email,
      required this.password,
      required this.profilePic,
      required this.posterPic,
      CancelToken? cancelToken})
      : super(cancelToken: cancelToken);
}

class FetchUserInfoEvent extends AuthEvent {
  const FetchUserInfoEvent({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class ReVerifyEvent extends AuthEvent {
  final String email;
  const ReVerifyEvent({required String this.email, CancelToken? cancelToken});
}

class ForgotPasswordEvent extends AuthEvent {
  final String usernameEmail;
  const ForgotPasswordEvent({required this.usernameEmail, CancelToken? cancelToken});
}

class ResetPasswordEvent extends AuthEvent {
  final String usernameEmail;
  final String otp;
  final String password;
  final String confirmPassword;

  const ResetPasswordEvent({required this.usernameEmail, required this.otp, required this.password, required this.confirmPassword, CancelToken? cancelToken});
}

class UpdateProfilePic extends AuthEvent {
  final MultipartFile profileImage;
  const UpdateProfilePic({required this.profileImage, CancelToken? cancelToken});
}

class UpdatePosterPicEvent extends AuthEvent {
  final MultipartFile posterImage;
  const UpdatePosterPicEvent({required this.posterImage, CancelToken? cancelToken});
}

class DeleteMeEvent extends AuthEvent {
  const DeleteMeEvent({CancelToken? cancelToken});
}

class UpdatePasswordEvent extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const UpdatePasswordEvent({required this.oldPassword, required this.newPassword, required this.confirmPassword, CancelToken? cancelToken});
}

class GetAllUsersEvent extends AuthEvent {
  final int? pageNo;
  final int? pageSize;

  const GetAllUsersEvent({this.pageNo, this.pageSize, CancelToken? cancelToken});
}

class DeleteUserEvent extends AuthEvent {
  final String userId;

  const DeleteUserEvent({required this.userId, CancelToken? cancelToken});
}

class GetUserEvent extends AuthEvent {
  final String userId;

  const GetUserEvent({required this.userId, CancelToken? cancelToken});
}

class AddRoleEvent extends AuthEvent {
  final String userId;
  final UserRole userRole;

  const AddRoleEvent({required this.userId, required this.userRole, CancelToken? cancelToken});
}
