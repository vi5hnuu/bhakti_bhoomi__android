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
    on<FetchBhagvadGeetaChapters>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBhagvadGeetaChapter>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBhagvadShlokByChapterIdShlokId>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBhagvadGeetaShloks>((event, emit) {
      // TODO: implement event handler
    });
  }
}
