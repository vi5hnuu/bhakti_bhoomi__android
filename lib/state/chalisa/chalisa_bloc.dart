import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/chalisa/ChalisaModel.dart';
import 'package:bhakti_bhoomi/services/chalisa/ChalisaRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'chalisa_event.dart';
part 'chalisa_state.dart';

class ChalisaBloc extends Bloc<ChalisaEvent, ChalisaState> {
  ChalisaBloc({required ChalisaRepository chalisaRepository}) : super(ChalisaState.initial()) {
    on<FetchAllChalisaInfo>((event, emit) async {
      if (state.chalisaInfos != null) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final chalisaInfoData = await chalisaRepository.getAllChalisaInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, chalisaInfo: Map.fromEntries(chalisaInfoData.data!.map((chalisaInfo) => MapEntry(chalisaInfo.id, chalisaInfo.title)))));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });

    on<FetchAllChalisa>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchChalisaById>((event, emit) async {
      if (state.chalisaExists(chalisaId: event.id)) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final chalisaData = await chalisaRepository.getChalisaById(id: event.id, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, chalisa: Map.fromEntries([...state.allChalisa.entries, state.getChalisaEntry(chalisa: chalisaData.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });

    on<FetchChalisaByTitle>((event, emit) {
      // TODO: implement event handler
    });
  }
}
