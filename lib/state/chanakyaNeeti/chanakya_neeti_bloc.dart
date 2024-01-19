import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/chanakyaNeeti/ChanakyaNeetiChapterInfoModel.dart';
import '../../models/chanakyaNeeti/ChanakyaNeetiVerseModel.dart';

part 'chanakya_neeti_event.dart';
part 'chanakya_neeti_state.dart';

class ChanakyaNeetiBloc extends Bloc<ChanakyaNeetiEvent, ChanakyaNeetiState> {
  ChanakyaNeetiBloc() : super(ChanakyaNeetiState.initial()) {
    on<ChanakyaNeetiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
