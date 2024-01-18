import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'rigveda_event.dart';
part 'rigveda_state.dart';

class RigvedaBloc extends Bloc<RigvedaEvent, RigvedaState> {
  RigvedaBloc() : super(RigvedaInitial()) {
    on<RigvedaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
