import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mahabharat_event.dart';
part 'mahabharat_state.dart';

class MahabharatBloc extends Bloc<MahabharatEvent, MahabharatState> {
  MahabharatBloc() : super(MahabharatInitial()) {
    on<MahabharatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
