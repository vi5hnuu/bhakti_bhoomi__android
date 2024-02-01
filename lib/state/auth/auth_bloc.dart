import 'dart:io';

import 'package:bhakti_bhoomi/constants/Constants.dart';
import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/UserRole.dart';
import 'package:bhakti_bhoomi/services/auth/AuthRepository.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';
import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
        ApiResponse<UserInfo> res = await authRepository.login(usernameEmail: event.usernameEmail, password: event.password, cancelToken: event.cancelToken);
        emit(AuthState(success: res.success, isAuthenticated: res.success, userInfo: res.data, message: res.message));
      } on DioException catch (e) {
        emit(AuthState(error: Utils.handleDioException(e)));
      } catch (e) {
        emit(AuthState(error: e.toString()));
      }
    });

    on<TryAuthenticatingEvent>((event, emit) async {
      emit(const AuthState());
      try {
        final cookie = await _getCookie();
        final isValidCookie = _isCookieValid(cookie);
        if (isValidCookie) DioSingleton().addCookie(Constants.jwtKey, cookie!); //add cookie for further requests
        emit(AuthState(isLoading: false, success: isValidCookie, isAuthenticated: isValidCookie, message: isValidCookie ? "logged in successfully" : null));
      } on DioException catch (e) {
        emit(AuthState(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(AuthState(isLoading: false, error: e.toString()));
      }
    });

    on<FetchUserInfoEvent>((event, emit) async {
      if (state.userInfo != null) return emit(state.copyWith(isLoading: false));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        ApiResponse<UserInfo> res = await authRepository.me(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, success: res.success, isAuthenticated: true, userInfo: res.data, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(const AuthState(isLoading: true, error: null));
      try {
        ApiResponse res = await authRepository.register(
            firstName: event.firstName,
            lastName: event.lastName,
            userName: event.username,
            email: event.email,
            password: event.password,
            profileImage: event.profilePic,
            posterImage: event.posterPic,
            cancelToken: event.cancelToken);
        emit(AuthState(isLoading: false, success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(AuthState(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(AuthState(isLoading: false, error: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null, isAuthenticated: state.isAuthenticated));
      try {
        final res = await authRepository.logout(cancelToken: event.cancelToken);
        await _sStorage.storage.delete(key: Constants.jwtKey);
        emit(AuthState(isLoading: false, success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(AuthState(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(AuthState(isLoading: false, error: e.toString()));
      }
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(const AuthState(isLoading: true, error: null));
      try {
        final res = await authRepository.forgotPassword(usernameEmail: event.usernameEmail, cancelToken: event.cancelToken);
        emit(AuthState(isLoading: false, success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(AuthState(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(AuthState(isLoading: false, error: e.toString()));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(const AuthState(isLoading: true, error: null));
      try {
        final res =
            await authRepository.resetPassword(usernameEmail: event.usernameEmail, otp: event.otp, password: event.password, confirmPassword: event.confirmPassword, cancelToken: event.cancelToken);
        emit(AuthState(isLoading: false, success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(AuthState(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(AuthState(isLoading: false, error: e.toString()));
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
