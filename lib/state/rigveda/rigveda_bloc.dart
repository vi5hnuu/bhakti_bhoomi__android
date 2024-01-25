import 'package:bhakti_bhoomi/models/rigveda/RigvedaVerseModel.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/rigveda/RigvedaInfoModel.dart';

part 'rigveda_event.dart';
part 'rigveda_state.dart';

class RigvedaBloc extends Bloc<RigvedaEvent, RigvedaState> {
  RigvedaBloc({required RigvedaRepository rigvedaRepository}) : super(RigvedaState.initial()) {
    on<FetchRigvedaInfo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchVerseByMandalaSukta>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchVerseBySuktaId>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchVersesByMandala>((event, emit) {
      // TODO: implement event handler
    });
  }
}
