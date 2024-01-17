part of 'auth_state_bloc.dart';

@immutable
class AuthState {
  final UserInfo? userInfo;
  final bool error;
  final String? message;
  final bool success;
  final bool isLoading;

  const AuthState({this.isLoading = false, this.success = false, this.userInfo, this.error = false, this.message});

  bool get isLoggedIn {
    return success && userInfo != null;
  }
}
