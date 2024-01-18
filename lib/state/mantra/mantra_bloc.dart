import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mantra_event.dart';
part 'mantra_state.dart';

class MantraBloc extends Bloc<MantraEvent, MantraState> {
  MantraBloc() : super(MantraInitial()) {
    on<MantraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
