import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';
import 'package:bhakti_bhoomi/services/mantra/MantraRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'mantra_event.dart';
part 'mantra_state.dart';

class MantraBloc extends Bloc<MantraEvent, MantraState> {
  MantraBloc({required MantraRepository mantraRepository}) : super(MantraState.initial()) {
    on<FetchAllMantraInfo>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchAllMantra>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchMantraById>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchMantraByTitle>((event, emit) {
      // TODO: implement event handler
    });
  }
}
