import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasMangalacharanModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasVerseModel.dart';
import 'package:bhakti_bhoomi/services/ramcharitmanas/RamcharitmanasRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ramcharitmanas_event.dart';
part 'ramcharitmanas_state.dart';

class RamcharitmanasBloc extends Bloc<RamcharitmanasEvent, RamcharitmanasState> {
  RamcharitmanasBloc({required RamcharitmanasRepository ramcharitmanasRepository}) : super(RamcharitmanasState.initial()) {
    on<RamcharitmanasEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
