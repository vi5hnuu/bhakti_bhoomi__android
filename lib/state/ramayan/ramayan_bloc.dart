import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanSargaInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanShlokModel.dart';
import 'package:bhakti_bhoomi/services/ramayan/RamayanRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ramayan_event.dart';
part 'ramayan_state.dart';

class RamayanBloc extends Bloc<RamayanEvent, RamayanState> {
  RamayanBloc({required RamayanRepository ramayanRepository}) : super(RamayanState.initial()) {
    on<FetchRamayanInfo>((event, emit) async {
      if (state.ramayanInfo != null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.RAMAYANA_INFO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_INFO,const HttpState.loading())));
      try {
        final ramayanInfo = await ramayanRepository.getRamayanInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.RAMAYANA_INFO), ramayanInfo: ramayanInfo.data!));
      }   on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_INFO, HttpState.error(error: e.toString()))));
      }
    });

    on<FetchRamayanSargaInfo>((event, emit) async {
      // TODO: implement event handler
    });

    on<FetchRamayanSargasInfo>((event, emit) async {
      if (state.isSargaInfoPageLoaded(kand: event.kanda, pageNo: event.pageNo)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.RAMAYANA_SARGAS_INFO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_SARGAS_INFO,const HttpState.loading())));
      try {
        final ramayanSargasInfoData = await ramayanRepository.getRamayanSargasInfo(kanda: event.kanda, pageNo: event.pageNo, pageSize: RamayanState.defaultSargasInfoPageSize, cancelToken: event.cancelToken);
        emit(state.copyWith(
            httpStates:state.httpStates.clone()..remove(Httpstates.RAMAYANA_SARGAS_INFO),
            loadedPages: Map.fromEntries([...state.isPageLoaded.entries, state.getPageLoadedEntry(kanda: event.kanda, pageNo: event.pageNo)]),
            sargaInfo: Map.fromEntries([...state.allSargaInfo.entries, ...(ramayanSargasInfoData.data!).map((e) => state.getSargaInfoEntry(e))])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_SARGAS_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_SARGAS_INFO, HttpState.error(error: e.toString()))));
      }
    });

    on<FetchRamayanShlokByKandSargaNoShlokNo>((event, emit) async {
      if (state.shlokExists(kanda: event.kanda, sargaNo: event.sargaNo, shlokNo: event.shlokNo, lang: event.lang)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.RAMAYANA_SHLOK_BY_KANDA_SARGANO_SHLOKNO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_SHLOK_BY_KANDA_SARGANO_SHLOKNO,const HttpState.loading())));
      try {
        final shlokData =
            await ramayanRepository.getRamayanShlokByKandSargaNoShlokNo(kanda: event.kanda, sargaNo: event.sargaNo, shlokNo: event.shlokNo, lang: event.lang, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.RAMAYANA_SHLOK_BY_KANDA_SARGANO_SHLOKNO), shloks: Map.fromEntries([...state.allShloks.entries, state.getShlokEntry(shlokData.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_SHLOK_BY_KANDA_SARGANO_SHLOKNO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.RAMAYANA_SHLOK_BY_KANDA_SARGANO_SHLOKNO, HttpState.error(error: e.toString()))));
      }
    });

    on<FetchRamayanShlokByKandSargaIdShlokNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamayanShlokasByKandSargaNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamayanShlokasByKandSargaId>((event, emit) {
      // TODO: implement event handler
    });
  }
}
