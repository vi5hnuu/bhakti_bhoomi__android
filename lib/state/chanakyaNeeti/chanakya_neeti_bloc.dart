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
    on<FetchChanakyaNeetiChaptersInfo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchChanakyaNeetiChapterVerses>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchChanakyaNeetiVerseByChapterNoVerseNo>((event, emit) {
      // TODO: implement event handler
    });
  }
}
