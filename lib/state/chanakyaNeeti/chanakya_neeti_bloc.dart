import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/services/chanakyaNeeti/ChanakyaNeetiRepository.dart';
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
      if (state.allChaptersInfo != null) return emit(state.copyWith(isLoading: false, error: null));

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final chaptersInfo = await chanakyaNeetiRepository.getchanakyaNeetiChaptersInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, chaptersInfo: chaptersInfo.data!));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'something went wrong'));
      }
    });

    on<FetchChanakyaNeetiChapterVerses>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchChanakyaNeetiVerseByChapterNoVerseNo>((event, emit) async {
      if (state.verseExists(chapterNo: event.chapterNo, verseNo: event.verseNo)) return emit(state.copyWith(isLoading: false, error: null));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final verseData = await chanakyaNeetiRepository.getchanakyaNeetiVerseByChapterNoVerseNo(chapterNo: event.chapterNo, verseNo: event.verseNo, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, verses: Map.fromEntries([...state.allVerses.entries, state.getEntry(verseData.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'something went wrong'));
      }
    });
  }
}
