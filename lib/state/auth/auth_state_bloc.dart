import 'package:bhakti_bhoomi/constants/ApiUrls.dart';
import 'package:bhakti_bhoomi/models/LoginResponse.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../models/UserInfo.dart';

part 'auth_state.dart';
part 'auth_state_event.dart';

class AuthStateBloc extends Bloc<AuthStateEvent, AuthState> {
  LoginResponse? _loginResponse;
  bool isLoading = false;

  AuthStateBloc() : super(AuthState()) {
    on<LoginEvent>((event, emit) async {
      isLoading = true;
      try {
        LoginResponse loginResponse =
            await _login(event.usernameEmail, event.password);
        _loginResponse = loginResponse;
        emit(AuthState(
            isLogedIn: loginResponse.success,
            userInfo: loginResponse.data,
            error: !loginResponse.success,
            message: loginResponse.message));
      } catch (e) {
        print(e);
      } finally {
        isLoading = false;
      }
    });
  }

  @override
  void onTransition(Transition<AuthStateEvent, AuthState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  UserInfo? get userInfo => _loginResponse?.data;
  bool get isLoggedIn => _loginResponse?.data != null;

  Future<LoginResponse> _login(String usernameEmail, String password) async {
    var loginResponse = await Dio().post(ApiUrls.getLoginUrl(), data: {
      "usernameEmail": usernameEmail,
      "password": password,
    });
    return LoginResponse.fromJson(loginResponse.data);
  }
}
