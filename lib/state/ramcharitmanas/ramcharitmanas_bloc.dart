import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasMangalacharanModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasVerseModel.dart';
import 'package:bhakti_bhoomi/services/ramcharitmanas/RamcharitmanasRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ramcharitmanas_event.dart';
part 'ramcharitmanas_state.dart';

class RamcharitmanasBloc extends Bloc<RamcharitmanasEvent, RamcharitmanasState> {
  RamcharitmanasBloc({required RamcharitmanasRepository ramcharitmanasRepository}) : super(RamcharitmanasState.initial()) {
    on<FetchRamcharitmanasInfo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamcharitmanasVerseById>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamcharitmanasVerseByKandaAndVerseNo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamcharitmanasMangalacharanByKanda>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamcharitmanasAllMangalacharan>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchRamcharitmanasVersesByKand>((event, emit) {
      // TODO: implement event handler
    });
  }
}
