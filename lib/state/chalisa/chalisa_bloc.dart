import 'package:bhakti_bhoomi/models/chalisa/ChalisaInfoModel.dart';
import 'package:bhakti_bhoomi/models/chalisa/ChalisaModel.dart';
import 'package:bhakti_bhoomi/services/chalisa/ChalisaRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'chalisa_event.dart';
part 'chalisa_state.dart';

class ChalisaBloc extends Bloc<ChalisaEvent, ChalisaState> {
  ChalisaBloc({required ChalisaRepository chalisaRepository}) : super(ChalisaState.initial()) {
    on<ChalisaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
