import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraModel.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/yogaSutra/YogaSutraInfoModel.dart';

part 'yoga_sutra_event.dart';
part 'yoga_sutra_state.dart';

class YogaSutraBloc extends Bloc<YogaSutraEvent, YogaSutraState> {
  YogaSutraBloc({required YogaSutraRepository yogaSutraRepository}) : super(YogaSutraState.initial()) {
    on<FetchYogasutraInfo>((event, emit) async {
      if (state.yogaSutraInfo != null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.YOGASUTRA_INFO)));
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.YOGASUTRA_INFO,const HttpState.loading())));

        final yogasutraInfo = await yogaSutraRepository.getyogasutraInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.YOGASUTRA_INFO), yogaSutraInfo: yogasutraInfo.data!));
      }   on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.YOGASUTRA_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.YOGASUTRA_INFO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });
    on<FetchYogasutraBySutraId>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchYogasutraByChapterNoSutraNo>((event, emit) async {
      if (state.sutraExists(chapterNo: event.chapterNo, sutraNo: event.sutraNo, lang: event.lang)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO)));
      try {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO,const HttpState.loading())));

        final sutraData = await yogaSutraRepository.getYogasutraByChapterNoSutraNo(chapterNo: event.chapterNo, sutraNo: event.sutraNo, lang: event.lang, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO), sutras: Map.fromEntries([...state.sutras.entries, state.getSutraEntry(sutraData.data!)])));
      }   on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.YOGASUTRA_BY_CHAPTERNO_SUTRANO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });
    on<FetchYogasutrasByChapterNo>((event, emit) {
      // TODO: implement event handler
    });
  }
}
