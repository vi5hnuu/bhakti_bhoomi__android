import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaSuktaModel.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaRepository.dart';
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
      if (state.rigvedaInfo != null) return emit(state.copyWith(isLoading: false, error: null));
      try {
        emit(state.copyWith(isLoading: true, error: null));
        final rigvedaInfo = await rigvedaRepository.getRigvedaInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, rigvedaInfo: rigvedaInfo.data!));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });
    on<FetchVerseByMandalaSukta>((event, emit) async {
      if (state.suktaExists(mandala: event.mandalaNo, suktaNo: event.suktaNo)) return emit(state.copyWith(isLoading: false, error: null));
      try {
        emit(state.copyWith(isLoading: true, error: null));
        final suktaData = await rigvedaRepository.getVerseByMandalaSukta(mandalaNo: event.mandalaNo, suktaNo: event.suktaNo, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, suktas: Map.fromEntries([...state.allSuktas.entries, state.getSuktaEntry(suktaData.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
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
