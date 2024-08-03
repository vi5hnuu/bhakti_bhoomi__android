import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/services/aarti/AartiRepository.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/HttpState.dart';

part 'aarti_event.dart';
part 'aarti_state.dart';

class AartiBloc extends Bloc<AartiEvent, AartiState> {
  AartiBloc({required AartiRepository aartiRepository}) : super(const AartiState.initial()) {
    on<FetchAartiInfoEvent>((event, emit) async {
      if (state.aartisInfo.isNotEmpty) return emit(state.copyWith(httpState:  state.httpState.clone()..remove(Httpstates.AARTI_INFO)));
      emit(state.copyWith(httpState: state.httpState.clone()..put(Httpstates.AARTI_INFO,const HttpState.loading())));
      try {
        final aartiInfo = await aartiRepository.getAllAartiInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(aartisInfo: aartiInfo.data!,httpState:state.httpState.clone()..remove(Httpstates.AARTI_INFO)));
      } on DioException catch (e) {
        var data = e.response?.data;
        final error = data?['message'] ?? 'something went wrong';
        emit(state.copyWith(httpState: state.httpState.clone()..put(Httpstates.AARTI_INFO, HttpState.error(error: error))));
      }
    });

    on<FetchAartiEvent>((event, emit) async {
      if (state.aartis[event.aartiId] != null) return emit(state.copyWith(httpState:  state.httpState.clone()..remove(Httpstates.AARTIS)));
      emit(state.copyWith(httpState:  state.httpState.clone()..put(Httpstates.AARTIS,const HttpState.loading())));
      try {
        final aarti = await aartiRepository.getAartiById(id: event.aartiId, cancelToken: event.cancelToken);
        emit(state.copyWith(httpState:  state.httpState.clone()..remove(Httpstates.AARTIS), aartis: {...state.aartis, event.aartiId: aarti.data!}));
      } on DioException catch (e) {
        var data = e.response?.data;
        final error = data?['message'] ?? 'something went wrong';
        emit(state.copyWith(httpState: state.httpState.clone()..put(Httpstates.AARTIS, HttpState.error(error: error))));
      }
    });
  }
}
