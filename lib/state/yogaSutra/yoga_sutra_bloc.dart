import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraModel.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/yogaSutra/YogaSutraInfoModel.dart';

part 'yoga_sutra_event.dart';
part 'yoga_sutra_state.dart';

class YogaSutraBloc extends Bloc<YogaSutraEvent, YogaSutraState> {
  YogaSutraBloc({required YogaSutraRepository yogaSutraRepository}) : super(YogaSutraState.initial()) {
    on<YogaSutraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
