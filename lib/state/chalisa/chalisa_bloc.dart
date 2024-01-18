import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chalisa_event.dart';
part 'chalisa_state.dart';

class ChalisaBloc extends Bloc<ChalisaEvent, ChalisaState> {
  ChalisaBloc() : super(ChalisaInitial()) {
    on<ChalisaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
