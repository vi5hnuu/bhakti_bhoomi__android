import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BHagvadGeetaChapterModel.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BhagvadGeetaShlokModel.dart';
import 'package:bhakti_bhoomi/services/bhagvadGeeta/BhagvadGeetaRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'bhagvad_geeta_event.dart';
part 'bhagvad_geeta_state.dart';

class BhagvadGeetaBloc extends Bloc<BhagvadGeetaEvent, BhagvadGeetaState> {
  BhagvadGeetaBloc({required BhagvadGeetaRepository bhagvadGeetaRepository}) : super(BhagvadGeetaState.initial()) {
    on<FetchBhagvadGeetaChapters>((event, emit) async {
      if (state.bhagvadGeetaChapters != null) return emit(state.copyWith(isLoading: false));
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final allChaptersRes = await bhagvadGeetaRepository.getbhagvadGeetaChapters(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, bhagvadGeetaChapters: [...?state.bhagvadGeetaChapters, ...?allChaptersRes.data]));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'something went wrong'));
      }
    });

    on<FetchBhagvadShlokByChapterIdShlokId>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBhagvadShlokByChapterIdShlokNo>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBhagvadShlokByChapterNoShlokNo>((event, emit) async {
      if (state.shlokExists(chapterNo: event.chapterNo, shlokNo: event.shlokNo)) return emit(state.copyWith(isLoading: false, error: null)); //cache
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final shlok = await bhagvadGeetaRepository.getbhagvadShlokByChapterNoShlokNo(chapterNo: event.chapterNo, shlokNo: event.shlokNo, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, bhagvadGeetaShloks: Map.fromEntries([...state.bhagvadGeetaShloks.entries, state.getEntry(shlok.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'something went wrong'));
      }
    });

    on<FetchBhagvadGeetaShloks>((event, emit) {
      // TODO: implement event handler
    });
  }
}
