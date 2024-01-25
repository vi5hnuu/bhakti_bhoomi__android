import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanKandaInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanSargaInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanShlokModel.dart';
import 'package:bhakti_bhoomi/services/ramayan/RamayanRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ramayan_event.dart';
part 'ramayan_state.dart';

class RamayanBloc extends Bloc<RamayanEvent, RamayanState> {
  RamayanBloc({required RamayanRepository ramayanRepository}) : super(RamayanState.initial()) {
    on<RamayanEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
