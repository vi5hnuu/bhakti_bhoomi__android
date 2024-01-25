import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanKandaInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanSargaInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanShlokModel.dart';
import 'package:bhakti_bhoomi/services/ramayan/RamayanRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ramayan_event.dart';
part 'ramayan_state.dart';

class RamayanBloc extends Bloc<RamayanEvent, RamayanState> {
  RamayanBloc({required RamayanRepository ramayanRepository}) : super(RamayanState.initial()) {
    on<FetchRamayanInfo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamayanShlokByKandSargaNoShlokNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamayanShlokByKandSargaIdShlokNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamayanShlokasByKandSargaNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamayanShlokasByKandSargaId>((event, emit) {
      // TODO: implement event handler
    });
  }
}
