import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ramayan_event.dart';
part 'ramayan_state.dart';

class RamayanBloc extends Bloc<RamayanEvent, RamayanState> {
  RamayanBloc() : super(RamayanInitial()) {
    on<RamayanEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
