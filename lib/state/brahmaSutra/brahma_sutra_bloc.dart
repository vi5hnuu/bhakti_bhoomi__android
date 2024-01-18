import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'brahma_sutra_event.dart';
part 'brahma_sutra_state.dart';

class BrahmaSutraBloc extends Bloc<BrahmaSutraEvent, BrahmaSutraState> {
  BrahmaSutraBloc() : super(BrahmaSutraInitial()) {
    on<BrahmaSutraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
