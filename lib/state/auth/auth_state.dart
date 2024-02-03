part of 'auth_bloc.dart';

@immutable
class AuthState {
  final UserInfo? userInfo;
  final String? message;
  final bool success; //api call success fail
  final String? error;
  final bool isLoading;
  final bool isAuthenticated;

  const AuthState({this.isLoading = false, this.success = false, this.userInfo, this.error, this.message, this.isAuthenticated = false});

  AuthState copyWith({UserInfo? userInfo, String? message, bool? success, String? error, bool? isLoading, bool? isAuthenticated}) {
    return AuthState(
        userInfo: userInfo ?? this.userInfo,
        message: message,
        success: success ?? false,
        error: error,
        isLoading: isLoading ?? this.isLoading,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated);
  }
}
