import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/services/chanakyaNeeti/ChanakyaNeetiRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/chanakyaNeeti/ChanakyaNeetiChapterInfoModel.dart';
import '../../models/chanakyaNeeti/ChanakyaNeetiVerseModel.dart';

part 'chanakya_neeti_event.dart';
part 'chanakya_neeti_state.dart';

class ChanakyaNeetiBloc extends Bloc<ChanakyaNeetiEvent, ChanakyaNeetiState> {
  ChanakyaNeetiBloc({required ChanakyaNeetiRepository chanakyaNeetiRepository}) : super(ChanakyaNeetiState.initial()) {
    on<FetchChanakyaNeetiChaptersInfo>((event, emit) async {
      if (state.allChaptersInfo != null) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO,const HttpState.loading())));
      try {
        final chaptersInfo = await chanakyaNeetiRepository.getchanakyaNeetiChaptersInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO), chaptersInfo: chaptersInfo.data!));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchChanakyaNeetiChapterVerses>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchChanakyaNeetiVerseByChapterNoVerseNo>((event, emit) async {
      if (state.verseExists(chapterNo: event.chapterNo, verseNo: event.verseNo)) return emit(state.copyWith(httpStates:  state.httpStates.clone()..remove(Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO,const HttpState.loading())));
      try {
        final verseData = await chanakyaNeetiRepository.getchanakyaNeetiVerseByChapterNoVerseNo(chapterNo: event.chapterNo, verseNo: event.verseNo, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates:state.httpStates.clone()..remove(Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO), verses: Map.fromEntries([...state.allVerses.entries, state.getEntry(verseData.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });
  }
}
