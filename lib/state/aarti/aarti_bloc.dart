import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'aarti_event.dart';
part 'aarti_state.dart';

class AartiBloc extends Bloc<AartiEvent, AartiState> {
  AartiBloc() : super(AartiState.initial()) {
    on<AartiEvent>((event, emit) {});
  }
}
