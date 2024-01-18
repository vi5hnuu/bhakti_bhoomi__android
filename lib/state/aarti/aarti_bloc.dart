import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'aarti_event.dart';
part 'aarti_state.dart';

class AartiBloc extends Bloc<AartiEvent, AartiState> {
  AartiBloc() : super(AartiInitial()) {
    on<AartiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
