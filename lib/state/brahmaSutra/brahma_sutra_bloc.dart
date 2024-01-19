import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraChapterInfoModel.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraModel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'brahma_sutra_event.dart';
part 'brahma_sutra_state.dart';

class BrahmaSutraBloc extends Bloc<BrahmaSutraEvent, BrahmaSutraState> {
  BrahmaSutraBloc() : super(BrahmaSutraState.initial()) {
    on<BrahmaSutraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
