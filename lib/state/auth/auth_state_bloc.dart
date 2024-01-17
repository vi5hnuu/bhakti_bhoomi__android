import 'package:bhakti_bhoomi/services/AuthRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../models/UserInfo.dart';
import '../../models/response/ApiResponse.dart';

part 'auth_state.dart';
part 'auth_state_event.dart';

class AuthStateBloc extends Bloc<AuthStateEvent, AuthState> {
  final AuthRepository authRepository = AuthRepository();

  AuthStateBloc() : super(AuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthState(isLoading: true));
      String? error;
      try {
        ApiResponse<UserInfo> res = await authRepository.login(event.usernameEmail, event.password);
        emit(AuthState(success: res.success, userInfo: res.data, error: !res.success, message: res.message));
      } on DioException catch (e) {
        var data = e.response?.data;
        error = data?['message'] ?? 'something went wrong';
      } finally {
        emit(AuthState(
            isLoading: false, success: error == null || state.success, error: error != null || state.error, message: error ?? state.message, userInfo: error != null ? null : state.userInfo));
      }
    });
  }
}
