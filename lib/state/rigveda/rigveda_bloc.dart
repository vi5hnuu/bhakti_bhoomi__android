import 'package:bhakti_bhoomi/models/rigveda/RigvedaVerseModel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/rigveda/RigvedaInfoModel.dart';

part 'rigveda_event.dart';
part 'rigveda_state.dart';

class RigvedaBloc extends Bloc<RigvedaEvent, RigvedaState> {
  RigvedaBloc() : super(RigvedaState.initial()) {
    on<RigvedaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
