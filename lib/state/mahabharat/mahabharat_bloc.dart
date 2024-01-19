import 'package:bhakti_bhoomi/models/mahabharat/MahabharatShlokModel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/mahabharat/MahabharatBookInfoModel.dart';

part 'mahabharat_event.dart';
part 'mahabharat_state.dart';

class MahabharatBloc extends Bloc<MahabharatEvent, MahabharatState> {
  MahabharatBloc() : super(MahabharatState.initial()) {
    on<MahabharatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
