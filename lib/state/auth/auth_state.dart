part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable with WithHttpState{
  final UserInfo? userInfo;
  final String? message;
  final bool success; //api call success fail

  AuthState({Map<String,HttpState>? httpStates,this.success = false, this.userInfo, this.message}){
    this.httpStates.addAll(httpStates ?? {});
  }

  AuthState copyWith({UserInfo? userInfo, String? message, bool? success,Map<String, HttpState>? httpStates, bool? isAuthenticated}) {
    return AuthState(
        userInfo: userInfo ?? this.userInfo,
        message: message,
        success: success ?? false,
        httpStates: httpStates ?? this.httpStates);
  }

  get isAuthtenticated{
    return userInfo!=null;
  }

  @override
  List<Object?> get props => [httpStates, userInfo,message,success];
}
