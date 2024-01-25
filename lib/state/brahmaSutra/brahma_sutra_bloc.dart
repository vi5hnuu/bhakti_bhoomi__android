import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraChapterInfoModel.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraModel.dart';
import 'package:bhakti_bhoomi/services/brahmaSutra/BrahmaSutraRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'brahma_sutra_event.dart';
part 'brahma_sutra_state.dart';

class BrahmaSutraBloc extends Bloc<BrahmaSutraEvent, BrahmaSutraState> {
  BrahmaSutraBloc({required BrahmaSutraRepository brahmaSutraRepository}) : super(BrahmaSutraState.initial()) {
    on<FetchBrahmasutraInfo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchBrahmasutraBySutraId>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchBrahmasutraBySutraId>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchBrahmasutraByChapterNoQuaterNoSutraNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchBrahmasutraByChapterNoQuaterNoSutraNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchBrahmasutrasByChapterNoQuaterNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchBrahmasutrasByChapterNoQuaterNo>((event, emit) {
      // TODO: implement event handler
    });
  }
}
