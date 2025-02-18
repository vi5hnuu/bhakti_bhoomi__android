import 'dart:io';

import 'package:bhakti_bhoomi/constants/Constants.dart';
import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/UserRole.dart';
import 'package:bhakti_bhoomi/services/auth/AuthRepository.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';
import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../models/UserInfo.dart';
import '../../models/response/ApiResponse.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final _sStorage = SecureStorage();

  AuthBloc({required this.authRepository}) : super(AuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(httpStates:  state.httpStates.clone()..put(Httpstates.LOGIN,const HttpState.loading())));
      try {
        ApiResponse<UserInfo> res = await authRepository.login(usernameEmail: event.usernameEmail, password: event.password, cancelToken: event.cancelToken);
        emit(AuthState(success: res.success,userInfo: res.data, message: res.message,httpStates: state.httpStates.clone()..remove(Httpstates.LOGIN)));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.LOGIN, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.LOGIN, HttpState.error(error: e.toString()))));
      }
    });

    on<TryAuthenticatingEvent>((event, emit) async {
      print("state-event TryAuthenticatingEvent");
      emit(AuthState().copyWith(httpStates:  state.httpStates.clone()..put(Httpstates.TRY_AUTH,const HttpState.loading())));
      try {
        final cookie = await _getCookie();
        final isValidCookie = _isCookieValid(cookie);
        if(!isValidCookie) await _clearCookies();
        if(isValidCookie) DioSingleton().addCookie(Constants.jwtKey, cookie!); //add cookie for further requests
        ApiResponse<UserInfo> res = await authRepository.me(cancelToken: event.cancelToken);
        emit(AuthState(userInfo: res.data,httpStates:state.httpStates.clone()..remove(Httpstates.TRY_AUTH), success: res.success, message: res.success ? "logged in successfully" : null));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.TRY_AUTH, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.TRY_AUTH, HttpState.error(error: e.toString()))));
      }
    });

    on<FetchUserInfoEvent>((event, emit) async {
      print("state-event FetchUserInfoEvent");
      if (state.userInfo != null) return emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.USER_INFO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.USER_INFO,const HttpState.loading())));
      try {
        ApiResponse<UserInfo> res = await authRepository.me(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.USER_INFO), success: res.success, userInfo: res.data, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.USER_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.USER_INFO, HttpState.error(error: e.toString()))));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthState().copyWith(httpStates: state.httpStates.clone()..put(Httpstates.REGISTER,const HttpState.loading())));
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
        emit(AuthState(httpStates: state.httpStates.clone()..remove(Httpstates.REGISTER), success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.REGISTER, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.REGISTER, HttpState.error(error: e.toString()))));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.LOG_OUT,const HttpState.loading())));
      try {
        final res = await authRepository.logout(cancelToken: event.cancelToken);
        await _sStorage.storage.delete(key: Constants.jwtKey);
        emit(AuthState());
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.LOG_OUT, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.LOG_OUT, HttpState.error(error: e.toString()))));
      }
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthState().copyWith(httpStates: state.httpStates.clone()..put(Httpstates.FORGOT_PASSWORD,const HttpState.loading())));
      try {
        final res = await authRepository.forgotPassword(usernameEmail: event.usernameEmail, cancelToken: event.cancelToken);
        emit(AuthState(httpStates: state.httpStates.clone()..remove(Httpstates.FORGOT_PASSWORD), success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.FORGOT_PASSWORD, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.FORGOT_PASSWORD, HttpState.error(error: e.toString()))));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthState().copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RESET_PASSWORD,const HttpState.loading())));
      try {
        final res =
            await authRepository.resetPassword(usernameEmail: event.usernameEmail, otp: event.otp, password: event.password, confirmPassword: event.confirmPassword, cancelToken: event.cancelToken);
        emit(AuthState(httpStates: state.httpStates.clone()..remove(Httpstates.RESET_PASSWORD), success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RESET_PASSWORD, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RESET_PASSWORD, HttpState.error(error: e.toString()))));
      }
    });

    on<UpdatePosterPicEvent>((event, emit) async {
      if (state.userInfo == null) throw Error(); //developer fault
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_POSTER_PIC,const HttpState.loading())));
      try {
        final res = await authRepository.updatePosterPic(posterImage: event.posterImage, userId: state.userInfo!.id, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.UPDATE_POSTER_PIC), success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_POSTER_PIC, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_POSTER_PIC, HttpState.error(error: e.toString()))));
      }
    });

    on<UpdateProfilePic>((event, emit) async {
      if (state.userInfo == null) throw Error(); //developer fault
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_PROFILE_PIC,const HttpState.loading())));
      try {
        final res = await authRepository.updateProfilePic(profileImage: event.profileImage, userId: state.userInfo!.id, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.UPDATE_PROFILE_PIC), success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_PROFILE_PIC, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_PROFILE_PIC, HttpState.error(error: e.toString()))));
      }
    });

    on<UpdatePasswordEvent>((event, emit) async {
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_PASSWORD,const HttpState.loading())));
      try {
        final res = await authRepository.updatePassword(oldPassword: event.oldPassword, newPassword: event.newPassword, confirmPassword: event.confirmPassword, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.UPDATE_PASSWORD), success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_PASSWORD, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.UPDATE_PASSWORD, HttpState.error(error: e.toString()))));
      }
    });
    on<DeleteMeEvent>((event, emit) async {
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.DELETE_ME,const HttpState.loading())));
      try {
        final res = await authRepository.deleteMe(cancelToken: event.cancelToken);
        await this._sStorage.storage.delete(key: Constants.jwtKey);
        emit(AuthState(httpStates: state.httpStates.clone()..remove(Httpstates.DELETE_ME), success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.DELETE_ME, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.DELETE_ME, HttpState.error(error: e.toString()))));
      }
    });
    on<ReVerifyEvent>((event, emit) async {
      emit(AuthState().copyWith(httpStates: state.httpStates.clone()..put(Httpstates.REVERIFY,const HttpState.loading())));
      try {
        final res = await authRepository.reVerify(email: event.email, cancelToken: event.cancelToken);
        emit(AuthState(httpStates: state.httpStates.clone()..remove(Httpstates.REVERIFY), success: res.success, message: res.message));
      } on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.REVERIFY, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.REVERIFY, HttpState.error(error: e.toString()))));
      }
    });
  }

  Future<Cookie?> _getCookie() async {
    var cookie = await _sStorage.storage.read(key: Constants.jwtKey);
    return cookie != null ? Cookie.fromSetCookieValue(cookie) : null;
  }

  _clearCookies() async {
    await _sStorage.storage.deleteAll();
  }

  bool _isCookieValid(Cookie? cookie) {
    if (cookie == null) return false;
    return cookie.expires!.isAfter(DateTime.now().add(Duration(minutes: 5)));
  }
}
