import 'package:bhakti_bhoomi/constants/Utils.dart';
import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraModel.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraRepository.dart';
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
      if (state.yogaSutraInfo != null) return emit(state.copyWith(isLoading: false, error: null));
      try {
        emit(state.copyWith(isLoading: true, error: null));
        final yogasutraInfo = await yogaSutraRepository.getyogasutraInfo(cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, yogaSutraInfo: yogasutraInfo.data!));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });
    on<FetchYogasutraBySutraId>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchYogasutraByChapterNoSutraNo>((event, emit) async {
      if (state.sutraExists(chapterNo: event.chapterNo, sutraNo: event.sutraNo, lang: event.lang)) return emit(state.copyWith(isLoading: false, error: null));
      try {
        emit(state.copyWith(isLoading: true, error: null));
        final sutraData = await yogaSutraRepository.getYogasutraByChapterNoSutraNo(chapterNo: event.chapterNo, sutraNo: event.sutraNo, lang: event.lang, cancelToken: event.cancelToken);
        emit(state.copyWith(isLoading: false, sutras: Map.fromEntries([...state.sutras.entries, state.getSutraEntry(sutraData.data!)])));
      } on DioException catch (e) {
        emit(state.copyWith(isLoading: false, error: Utils.handleDioException(e)));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "something went wrong"));
      }
    });
    on<FetchYogasutrasByChapterNo>((event, emit) {
      // TODO: implement event handler
    });
  }
}
