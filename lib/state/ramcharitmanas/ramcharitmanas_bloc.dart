import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ramcharitmanas_event.dart';
part 'ramcharitmanas_state.dart';

class RamcharitmanasBloc extends Bloc<RamcharitmanasEvent, RamcharitmanasState> {
  RamcharitmanasBloc() : super(RamcharitmanasInitial()) {
    on<RamcharitmanasEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
