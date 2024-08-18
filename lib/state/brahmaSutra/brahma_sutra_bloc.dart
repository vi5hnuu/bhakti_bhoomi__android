import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraModel.dart';
import 'package:bhakti_bhoomi/services/brahmaSutra/BrahmaSutraRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'brahma_sutra_event.dart';
part 'brahma_sutra_state.dart';

class BrahmaSutraBloc extends Bloc<BrahmaSutraEvent, BrahmaSutraState> {
  BrahmaSutraBloc({required BrahmaSutraRepository brahmaSutraRepository}) : super(BrahmaSutraState.initial()) {
    on<FetchBrahmasutraInfo>((event, emit) async {
      if (state.brahmasutraInfo != null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.BRAHMA_SUTRA_INFO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BRAHMA_SUTRA_INFO,const HttpState.loading())));
      try {
        final brahmasutraInfoData = await brahmaSutraRepository.getBrahmasutraInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.BRAHMA_SUTRA_INFO), brahmasutraInfo: brahmasutraInfoData.data!));
      }   on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BRAHMA_SUTRA_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BRAHMA_SUTRA_INFO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchBrahmasutraBySutraId>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBrahmasutraByChapterNoQuaterNoSutraNo>((event, emit) async {
      if (state.brahmaSutraExists(chapterNo: event.chapterNo, quaterNo: event.quaterNo, sutraNo: event.sutraNo, lang: event.lang)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO,const HttpState.loading())));
      try {
        final sutraData = await brahmaSutraRepository.getbrahmasutraByChapterNoQuaterNoSutraNo(
            chapterNo: event.chapterNo, quaterNo: event.quaterNo, sutraNo: event.sutraNo, lang: event.lang, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO), brahmaSutras: Map.fromEntries([...state.brahmaSutras.entries, state.getBrahmaSutraEntry(brahmaSutra: sutraData.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BRAHMA_SUTRA_BY_CHAPTERNO_QUATERNO_SUTRANO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchBrahmasutrasByChapterNoQuaterNo>((event, emit) {
      // TODO: implement event handler
    });
  }
}
