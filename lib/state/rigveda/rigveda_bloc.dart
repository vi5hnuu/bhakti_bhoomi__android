import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaSuktaModel.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/rigveda/RigvedaInfoModel.dart';

part 'rigveda_event.dart';
part 'rigveda_state.dart';

class RigvedaBloc extends Bloc<RigvedaEvent, RigvedaState> {
  RigvedaBloc({required RigvedaRepository rigvedaRepository}) : super(RigvedaState.initial()) {
    on<FetchRigvedaInfo>((event, emit) async {
      if (state.rigvedaInfo != null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.RIGVEDA_INFO)));
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RIGVEDA_INFO,const HttpState.loading())));
        final rigvedaInfo = await rigvedaRepository.getRigvedaInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.RIGVEDA_INFO), rigvedaInfo: rigvedaInfo.data!));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RIGVEDA_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RIGVEDA_INFO, HttpState.error(error: e.toString()))));
      }
    });
    on<FetchVerseByMandalaSukta>((event, emit) async {
      if (state.suktaExists(mandala: event.mandalaNo, suktaNo: event.suktaNo)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA)));
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA,const HttpState.loading())));
        final suktaData = await rigvedaRepository.getVerseByMandalaSukta(mandalaNo: event.mandalaNo, suktaNo: event.suktaNo, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA), suktas: Map.fromEntries([...state.allSuktas.entries, state.getSuktaEntry(suktaData.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RIGVEDA_VERSE_BY_MANDALA_SUKTA, HttpState.error(error: e.toString()))));
      }
    });
    on<FetchVerseBySuktaId>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchVersesByMandala>((event, emit) {
      // TODO: implement event handler
    });
  }
}
