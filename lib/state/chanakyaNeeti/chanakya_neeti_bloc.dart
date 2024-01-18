import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chanakya_neeti_event.dart';
part 'chanakya_neeti_state.dart';

class ChanakyaNeetiBloc extends Bloc<ChanakyaNeetiEvent, ChanakyaNeetiState> {
  ChanakyaNeetiBloc() : super(ChanakyaNeetiInitial()) {
    on<ChanakyaNeetiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
