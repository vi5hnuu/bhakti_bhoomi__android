import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/services/aarti/AartiRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'aarti_event.dart';
part 'aarti_state.dart';

class AartiBloc extends Bloc<AartiEvent, AartiState> {
  AartiBloc({required AartiRepository aartiRepository}) : super(const AartiState.initial()) {
    on<FetchAartiInfoEvent>((event, emit) async {
      if (state.aartisInfo.isNotEmpty) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final aartiInfo = await aartiRepository.getAllAartiInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, aartisInfo: aartiInfo.data!));
      } on DioException catch (e) {
        var data = e.response?.data;
        final error = data?['message'] ?? 'something went wrong';
        emit(state.copyWith(isLoading: false, error: error));
      }
    });

    on<FetchAartiEvent>((event, emit) async {
      if (state.aartis[event.aartiId] != null) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final aarti = await aartiRepository.getAartiById(id: event.aartiId, cancelToken: event.cancelToken);
        final newState = state.copyWith(isLoading: false, aartis: {...state.aartis, event.aartiId: aarti.data!});
        emit(newState);
      } on DioException catch (e) {
        var data = e.response?.data;
        final error = data?['message'] ?? 'something went wrong';
        emit(state.copyWith(isLoading: false, error: error));
      }
    });
  }
}
