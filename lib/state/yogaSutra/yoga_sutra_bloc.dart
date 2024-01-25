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
    on<FetchYogasutraInfo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchYogasutraBySutraId>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchYogasutraBySutraId>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchYogasutraByChapterNoSutraNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchYogasutraByChapterNoSutraNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchYogasutrasByChapterNo>((event, emit) {
      // TODO: implement event handler
    });
  }
}
