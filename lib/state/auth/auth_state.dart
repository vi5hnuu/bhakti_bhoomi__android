part of 'auth_bloc.dart';

@immutable
class AuthState {
  final UserInfo? userInfo;
  final String? message;
  final bool success;
  final String? error;
  final bool isLoading;

  const AuthState({this.isLoading = true, this.success = false, this.userInfo, this.error, this.message});

  AuthState copyWith({UserInfo? userInfo, String? message, bool? success, String? error, bool? isLoading}) {
    return AuthState(
      userInfo: userInfo ?? this.userInfo,
      message: message ?? this.message,
      success: success ?? this.success,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isAuthenticated {
    return success;
  }
}
