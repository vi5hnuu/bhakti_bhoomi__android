import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraGroupModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/services/mantra/MantraRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'mantra_event.dart';
part 'mantra_state.dart';

class MantraBloc extends Bloc<MantraEvent, MantraState> {
  MantraBloc({required MantraRepository mantraRepository}) : super(MantraState.initial()) {
    on<FetchAllMantraInfo>((event, emit) async {
      if (state.allMantraInfo != null) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final mantrasInfo = await mantraRepository.getAllMantraInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, mantraInfo: Map.fromEntries(mantrasInfo.data!.map((mantraInfo) => MapEntry(mantraInfo.id, mantraInfo)))));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });
    on<FetchAllMantra>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchMantraById>((event, emit) async {
      if (state.mantraExists(mantraId: event.id)) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final mantraData = await mantraRepository.getMantraById(id: event.id, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, mantras: Map.fromEntries([...state.allMantras.entries, state.getMantraEntry(mantra: mantraData.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });
    on<FetchMantraByTitle>((event, emit) {
      // TODO: implement event handler
    });
  }
}
