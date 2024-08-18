import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/extensions/map-entensions.dart';
import 'package:bhakti_bhoomi/models/HttpState.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BHagvadGeetaChapterModel.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BhagvadGeetaShlokModel.dart';
import 'package:bhakti_bhoomi/services/bhagvadGeeta/BhagvadGeetaRepository.dart';
import 'package:bhakti_bhoomi/state/WithHttpState.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'bhagvad_geeta_event.dart';
part 'bhagvad_geeta_state.dart';

class BhagvadGeetaBloc extends Bloc<BhagvadGeetaEvent, BhagvadGeetaState> {
  BhagvadGeetaBloc({required BhagvadGeetaRepository bhagvadGeetaRepository}) : super(BhagvadGeetaState.initial()) {
    on<FetchBhagvadGeetaChapters>((event, emit) async {
      if (state.bhagvadGeetaChapters != null) return emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.BHAGVAD_GEETA_CHAPTERS)));
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BHAGVAD_GEETA_CHAPTERS,const HttpState.loading())));
      try {
        final allChaptersRes = await bhagvadGeetaRepository.getbhagvadGeetaChapters(cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.BHAGVAD_GEETA_CHAPTERS), bhagvadGeetaChapters: [...?state.bhagvadGeetaChapters, ...?allChaptersRes.data]));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BHAGVAD_GEETA_CHAPTERS, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BHAGVAD_GEETA_CHAPTERS, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchBhagvadShlokByChapterIdShlokId>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBhagvadShlokByChapterIdShlokNo>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBhagvadShlokByChapterNoShlokNo>((event, emit) async {
      if (state.shlokExists(chapterNo: event.chapterNo, shlokNo: event.shlokNo)) return emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO))); //cache
      emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO,const HttpState.loading())));
      try {
        final shlok = await bhagvadGeetaRepository.getbhagvadShlokByChapterNoShlokNo(chapterNo: event.chapterNo, shlokNo: event.shlokNo, cancelToken: event.cancelToken);
        emit(state.copyWith(httpStates: state.httpStates.clone()..remove(Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO), bhagvadGeetaShloks: Map.fromEntries([...state.bhagvadGeetaShloks.entries, state.getEntry(shlok.data!)])));
      }  on DioException catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO, HttpState.error(error: Utils.handleDioException(e)))));
      } catch (e) {
        emit(state.copyWith(httpStates: state.httpStates.clone()..put(Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO, HttpState.error(error: ErrorModel(message:e.toString())))));
      }
    });

    on<FetchBhagvadGeetaShloks>((event, emit) {
      // TODO: implement event handler
    });
  }
}
