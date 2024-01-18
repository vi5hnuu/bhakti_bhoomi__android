import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'yoga_sutra_event.dart';
part 'yoga_sutra_state.dart';

class YogaSutraBloc extends Bloc<YogaSutraEvent, YogaSutraState> {
  YogaSutraBloc() : super(YogaSutraInitial()) {
    on<YogaSutraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
