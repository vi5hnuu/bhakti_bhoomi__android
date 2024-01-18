import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bhagvad_geeta_event.dart';
part 'bhagvad_geeta_state.dart';

class BhagvadGeetaBloc extends Bloc<BhagvadGeetaEvent, BhagvadGeetaState> {
  BhagvadGeetaBloc() : super(BhagvadGeetaInitial()) {
    on<BhagvadGeetaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
