part of 'auth_state_bloc.dart';

@immutable
class AuthState {
  bool isLogedIn;
  UserInfo? userInfo;
  bool? error;
  String? message;

  AuthState({this.isLogedIn = false, this.userInfo, this.error, this.message});
}
