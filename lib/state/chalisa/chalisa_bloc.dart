import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/chalisa/ChalisaModel.dart';
import 'package:bhakti_bhoomi/services/chalisa/ChalisaRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'chalisa_event.dart';
part 'chalisa_state.dart';

class ChalisaBloc extends Bloc<ChalisaEvent, ChalisaState> {
  ChalisaBloc({required ChalisaRepository chalisaRepository}) : super(ChalisaState.initial()) {
    on<FetchAllChalisaInfo>((event, emit) async {
      if (state.chalisaInfos != null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.ALL_CHALISA_INFO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.ALL_CHALISA_INFO,const HttpState.loading())));
      try {
        final chalisaInfoData = await chalisaRepository.getAllChalisaInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.ALL_CHALISA_INFO), chalisaInfo: Map.fromEntries(chalisaInfoData.data!.map((chalisaInfo) => MapEntry(chalisaInfo.id, chalisaInfo.title)))));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.ALL_CHALISA_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.ALL_CHALISA_INFO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchAllChalisa>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchChalisaById>((event, emit) async {
      if (state.chalisaExists(chalisaId: event.id)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.CHALISA_BY_ID)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHALISA_BY_ID,const HttpState.loading())));
      try {
        final chalisaData = await chalisaRepository.getChalisaById(id: event.id, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.CHALISA_BY_ID), chalisa: Map.fromEntries([...state.allChalisa.entries, state.getChalisaEntry(chalisa: chalisaData.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHALISA_BY_ID, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHALISA_BY_ID, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchChalisaByTitle>((event, emit) {
      // TODO: implement event handler
    });
  }
}
