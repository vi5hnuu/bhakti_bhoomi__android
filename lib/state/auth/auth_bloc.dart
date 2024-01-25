import 'dart:io';

import 'package:bhakti_bhoomi/constants/Constants.dart';
import 'package:bhakti_bhoomi/services/auth/AuthRepository.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';
import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../models/UserInfo.dart';
import '../../models/response/ApiResponse.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final _sStorage = SecureStorage();

  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(const AuthState(isLoading: true, error: null));
      try {
        ApiResponse<UserInfo> res = await authRepository.login(usernameEmail: event.usernameEmail, password: event.password);
        emit(AuthState(success: res.success, userInfo: res.data, message: res.message));
      } catch (e) {
        var error = (e is DioException) ? (e.response?.data.toString()) : 'something went wrong';
        emit(AuthState(isLoading: false, error: error));
      }
    });

    on<TryAuthenticatingEvent>((event, emit) async {
      emit(const AuthState());
      try {
        final cookie = await _getCookie();
        final isValidCookie = _isCookieValid(cookie);
        if (isValidCookie) DioSingleton().addCookie(Constants.jwtKey, cookie!); //add cookie for further requests
        emit(AuthState(isLoading: false, success: isValidCookie, message: isValidCookie ? "logged in successfully" : null));
      } catch (e) {
        var error = (e is DioException) ? (e.response?.data.toString()) : 'something went wrong';
        emit(AuthState(isLoading: false, error: error));
      }
    });

    on<FetchUserInfoEvent>((event, emit) async {
      if (state.userInfo != null) return emit(state.copyWith(isLoading: false));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        ApiResponse<UserInfo> res = await authRepository.me();
        emit(state.copyWith(isLoading: false, success: res.success, userInfo: res.data, message: res.message));
      } catch (e) {
        var error = (e is DioException) ? (e.response?.data.toString()) : 'something went wrong';
        emit(state.copyWith(isLoading: false, error: error));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final res = await authRepository.logout();
        await _sStorage.storage.delete(key: Constants.jwtKey);
        emit(AuthState(isLoading: false, success: false, message: res.message));
      } catch (e) {
        var error = (e is DioException) ? (e.response?.data.toString()) : 'something went wrong';
        emit(state.copyWith(isLoading: false, error: error));
      }
    });
  }

  Future<Cookie?> _getCookie() async {
    var cookie = await _sStorage.storage.read(key: Constants.jwtKey);
    return cookie != null ? Cookie.fromSetCookieValue(cookie) : null;
  }

  bool _isCookieValid(Cookie? cookie) {
    if (cookie == null) return false;
    return cookie.expires!.isAfter(DateTime.now().add(Duration(minutes: 5)));
  }
}
