import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'mantra_event.dart';
part 'mantra_state.dart';

class MantraBloc extends Bloc<MantraEvent, MantraState> {
  MantraBloc() : super(MantraState.initial()) {
    on<MantraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
