part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  final CancelToken? cancelToken;
  AuthEvent({this.cancelToken});
}

class LoginEvent extends AuthEvent {
  final String usernameEmail;
  final String password;

  LoginEvent({required this.usernameEmail, required this.password, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class TryAuthenticatingEvent extends AuthEvent {
  TryAuthenticatingEvent();
}

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final XFile? profilePic;
  final XFile? posterPic;

  RegisterEvent({required this.firstName, required this.lastName, required this.username, required this.email, required this.password, this.profilePic, this.posterPic, CancelToken? cancelToken})
      : super(cancelToken: cancelToken);
}

class FetchUserInfoEvent extends AuthEvent {
  FetchUserInfoEvent({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class LogoutEvent extends AuthEvent {
  LogoutEvent({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
